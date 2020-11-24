import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

double repeat(double t, double m) {
  return (t - (t / m).floor() * m).clamp(0, m);
}

double lerp(double a, double b, double t) {
  return a * (1 - t) + b * t;
}

double lerpTheta(double a, double b, double t) {
  double dt = repeat(b - a, 360);
  return lerp(a, a + (dt > 180 ? dt - 360 : dt), t);
}

LatLng lerpLatLng(LatLng a, LatLng b, double t) {
  return LatLng(lerpTheta(a.latitude, b.latitude, t),
      lerpTheta(a.longitude, b.longitude, t));
}

class ShowPickupDestinationMap extends StatefulWidget {
  // TODO: placeholder
  final pickup = LatLng(37.42796133580664, -122.085749655962);
  final dest = LatLng(37.43296265331129, -122.08832357078792);

  @override
  State<ShowPickupDestinationMap> createState() =>
      ShowPickupDestinationMapState();
}

class ShowPickupDestinationMapState extends State<ShowPickupDestinationMap> {
  Completer<GoogleMapController> _controller = Completer();

  BitmapDescriptor pickupIcon;
  BitmapDescriptor destIcon;

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'assets/images/pickup.png')
        .then((onValue) {
      setState(() => pickupIcon = onValue);
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'assets/images/dest.png')
        .then((onValue) {
      setState(() => destIcon = onValue);
    });
  }

  // LatLngBounds _bounds() {
  //   double minLong = min(widget.pickup.longitude, widget.dest.longitude);
  //   double maxLong = min(widget.pickup.longitude, widget.dest.longitude);
  //   double minLat = min(widget.pickup.latitude, widget.dest.latitude);
  //   double maxLat = max(widget.pickup.latitude, widget.dest.latitude);

  //   return LatLngBounds(
  //       southwest: LatLng(minLat, minLong), northeast: LatLng(maxLat, maxLong));
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
          target: lerpLatLng(widget.pickup, widget.dest, 0.5), zoom: 15),
      tiltGesturesEnabled: false,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: false,
      rotateGesturesEnabled: false,
      scrollGesturesEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        // controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds(), 200.0));
      },
      markers: Set.from([
        Marker(
            markerId: MarkerId("pickup"),
            consumeTapEvents: true,
            anchor: Offset(0.5, 0.5),
            position: widget.pickup,
            icon: pickupIcon),
        Marker(
            markerId: MarkerId("dest"),
            consumeTapEvents: true,
            position: widget.dest,
            anchor: Offset(0.5, 0.5),
            icon: destIcon)
      ]),
    ));
  }
}
