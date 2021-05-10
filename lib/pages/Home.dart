import 'package:carriage_rider/pages/ride-flow/Request_Ride_Loc.dart';
import 'package:carriage_rider/models/Ride.dart';
import 'package:carriage_rider/providers/AuthProvider.dart';
import 'package:carriage_rider/providers/LocationsProvider.dart';
import 'package:carriage_rider/pages/Notifications.dart';
import 'package:carriage_rider/pages/Profile.dart';
import 'package:carriage_rider/providers/RideFlowProvider.dart';
import 'package:carriage_rider/providers/RiderProvider.dart';
import 'package:carriage_rider/utils/app_config.dart';
import 'package:carriage_rider/providers/RidesProvider.dart';
import 'package:carriage_rider/widgets/CurrentRideCard.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/pages/Ride_History.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/semantics.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/pages/Contact.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:carriage_rider/widgets/ModifiedRefreshIndicator.dart';
import 'Upcoming.dart';

void main() {
  MaterialApp(routes: {
    '/': (context) => Home(),
  });
}

class HomeHeader extends StatefulWidget {
  final ScrollController homeScrollCtrl;
  final double height;
  HomeHeader(this.homeScrollCtrl, this.height);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  bool scrollAtTop;

  @override
  void initState() {
    super.initState();
    scrollAtTop = true;
    widget.homeScrollCtrl.addListener(() {
      setState(() {
        scrollAtTop = widget.homeScrollCtrl.position.pixels == 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: scrollAtTop ? [] : [BoxShadow(
              offset: Offset(0,2),
              blurRadius: 11,
              color: Colors.black.withOpacity(0.15)
          )]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Semantics(
                header: true,
                label: 'Hi ' + riderProvider.info.firstName,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 23),
                  child: ExcludeSemantics(
                    child: Text(
                      'Hi ' +
                          riderProvider.info.firstName +
                          '! ☀',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontFamily: 'SFPro',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 23),
                child: Builder(builder: (context) {
                  return Semantics(
                    label: 'Menu',
                    child: IconButton(
                        icon: Icon(Icons.menu,
                            color: Colors.black),
                        onPressed: () =>
                            Scaffold.of(context)
                                .openEndDrawer()),
                  );
                }),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController scrollCtrl = ScrollController();
  final GlobalKey<ModifiedRefreshIndicatorState> refreshKey = GlobalKey();

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(context) {
    RidesProvider ridesProvider = Provider.of<RidesProvider>(context);
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    LocationsProvider locationsProvider =
    Provider.of<LocationsProvider>(context);
    RideFlowProvider rideFlowProvider = Provider.of<RideFlowProvider>(context);
    AppConfig appConfig = AppConfig.of(context);
    double headerHeight = 100;

    Widget sideBarText(String text, Color color) {
      return Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(color: color, fontFamily: 'SFPro'),
      );
    }

    Widget buildPage() {
      return  NotificationListener<OverscrollNotification>(
          onNotification: (notif) {
            if (refreshKey.currentState.mode == RefreshIndicatorMode.drag) {
              SemanticsService.announce('Pull down to refresh rides', TextDirection.ltr);
            }
            else if (refreshKey.currentState.mode == RefreshIndicatorMode.armed) {
              SemanticsService.announce('Release to refresh rides', TextDirection.ltr);
            }
            return true;
          },
          child: ModifiedRefreshIndicator(
            key: refreshKey,
            semanticsLabel: 'Refreshing rides',
            onRefresh: () async {
              SemanticsService.announce('Refreshing rides', TextDirection.ltr);
              await ridesProvider.fetchAllRides(
                  appConfig, authProvider);
            },
            child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: scrollCtrl,
                    child: Column(
                      children: [
                        SizedBox(height: headerHeight),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Semantics(
                                  container: true,
                                  header: true,
                                  child: Text(
                                    'Current Ride',
                                    style: CarriageTheme.subHeading,
                                  ),
                                ),
                                SizedBox(height: 12),
                                CurrentRideCard(ridesProvider.currentRide,
                                    showCallDriver: true),
                              ]
                          ),
                        ),
                        SizedBox(height: 35),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(children: [
                            Semantics(
                              container: true,
                              header: true,
                              child: Text(
                                'Upcoming Rides',
                                style: CarriageTheme.subHeading,
                              ),
                            ),
                            Spacer(),
                            ridesProvider.upcomingRides.isNotEmpty
                                ? Semantics(
                              button: true,
                              container: true,
                              child: Container(
                                height: 48,
                                child: InkWell(
                                    onTap: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                        builder: (context) =>
                                            UpcomingSeeMore())),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: Row(children: [
                                        Text(
                                          'See More',
                                          style:
                                          CarriageTheme.seeMoreStyle,
                                          semanticsLabel:
                                          'See more upcoming rides',
                                        ),
                                        SizedBox(width: 4),
                                        Icon(Icons.arrow_forward,
                                            size: 16)
                                      ]),
                                    )),
                              ),
                            )
                                : Container()
                          ]),
                        ),
                        UpcomingRides(),
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(children: [
                            Semantics(
                              container: true,
                              header: true,
                              child: Text(
                                'Ride History',
                                style: CarriageTheme.subHeading,
                              ),
                            ),
                            Spacer(),
                            ridesProvider.pastRides.isNotEmpty
                                ? Semantics(
                              container: true,
                              button: true,
                              child: Container(
                                height: 48,
                                child: InkWell(
                                    onTap: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                        builder: (context) =>
                                            HistorySeeMore())),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: Row(children: [
                                        Text(
                                          'See More',
                                          style:
                                          CarriageTheme.seeMoreStyle,
                                          semanticsLabel:
                                          'See more past rides',
                                        ),
                                        SizedBox(width: 4),
                                        Icon(Icons.arrow_forward,
                                            size: 16)
                                      ]),
                                    )),
                              ),
                            )
                                : Container()
                          ]),
                        ),
                        SizedBox(height: 12),
                        RideHistory(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height:
                          MediaQuery.of(context).size.height / 8 + 36,
                        )
                      ],
                    ),
                  ),
                  HomeHeader(scrollCtrl, headerHeight)
                ]
            ),
          )
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      endDrawer: SafeArea(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.all(5.0),
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person, color: Colors.black),
                title: sideBarText('Profile', Colors.black),
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => Profile()));
                },
              ),
              Divider(
                color: Colors.grey[500],
              ),
              ListTile(
                leading: Icon(Icons.notifications, color: Colors.black),
                title: sideBarText('Notifications', Colors.black),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => Notifications()));
                },
              ),
              Divider(
                color: Colors.grey[500],
              ),
              ListTile(
                leading: Icon(Icons.help_outline, color: Colors.black),
                title: sideBarText('Contact', Colors.black),
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => Contact()));
                },
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: !ridesProvider.hasData() ||
            !locationsProvider.hasLocations() ||
            !riderProvider.hasInfo()
            ? Center(child: CircularProgressIndicator())
            : Stack(
          children: <Widget>[
            buildPage(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 8,
                decoration:
                BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      offset: Offset(0, -2),
                      blurRadius: 11,
                      spreadRadius: 5,
                      color: Colors.black.withOpacity(0.11))
                ]),
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.center,
                        child: ButtonTheme(
                          minWidth:
                          MediaQuery.of(context).size.width * 0.8,
                          height: 50.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: RaisedButton.icon(
                            onPressed: () {
                              rideFlowProvider.setLocControllers('', '');
                              rideFlowProvider.setEditing(false);
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          RequestRideLoc(
                                              ride: new Ride())));
                            },
                            elevation: 3.0,
                            color: Colors.black,
                            textColor: Colors.white,
                            icon: Icon(Icons.add),
                            label: Text('Request Ride',
                                style: TextStyle(fontSize: 18)),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
