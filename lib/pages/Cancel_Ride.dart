import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../utils/app_config.dart';
import '../models/Ride.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:convert';

class CancelRidePage extends StatefulWidget {
  CancelRidePage(this.ride);

  final Ride ride;

  @override
  _CancelRidePageState createState() => _CancelRidePageState();
}

class _CancelRidePageState extends State<CancelRidePage> {
  bool cancelRepeating;

  @override
  void initState() {
    super.initState();
    setState(() {
      cancelRepeating = false;
    });
  }

  Future<void> cancelRide(BuildContext context, Ride ride) async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    String token = await authProvider.secureStorage.read(key: 'token');
    http.Response response = await http.delete(
        AppConfig.of(context).baseUrl + '/rides/${ride.id}',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        });
    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => CancelConfirmation())
      );
    }
  }

  Future<void> cancelRepeatingRideOccurrence(BuildContext context, Ride ride) async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    String token = await authProvider.secureStorage.read(key: 'token');
    Map<String, dynamic> request = <String, dynamic>{
      'id': ride.id,
      'deleteOnly': true,
      'origDate': DateFormat('yyyy-MM-dd').format(ride.origDate),
    };
    final response = await http.put('${AppConfig.of(context).baseUrl}/rides/${ride.parentRide.id}/edits',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode(request));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete instance of recurring ride: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GestureDetector(
                  child: Text('Cancel', style: TextStyle(fontSize: 17)),
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
              SizedBox(height: 32),
              Text('Are you sure you want to cancel this ride?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 32),
              widget.ride.buildSummary(context),
              SizedBox(height: 32),
              CheckboxListTile(
                  activeColor: Color(0xFFA8A8A8),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: cancelRepeating,
                  onChanged: (bool newValue) {
                    setState(() {
                      cancelRepeating = newValue;
                    });
                  },
                  title: Text('Cancel all repeating rides',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFA8A8A8),
                          fontWeight: FontWeight.normal))),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Cancel Ride',
                          style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                    onPressed: () async {


                    },
                  ),
                ),
              )
            ]),
          ),
        ));
  }
}

class CancelConfirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
              SizedBox(height: 176),
              Image.asset('assets/images/cancel_ride_confirmed.png'),
              SizedBox(height: 32),
              Center(
                  child: Text('Your ride is cancelled!',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(34),
                child: Container(
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Done',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              )
            ])));
  }
}
