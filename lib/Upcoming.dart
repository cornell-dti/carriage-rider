import 'package:flutter/material.dart';

class Upcoming extends StatefulWidget {
  @override
  _UpcomingState createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Schedule', style: TextStyle(
              color: Colors.black, fontSize: 20, fontFamily: 'SFPro')),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: Stack(
          children: <Widget>[
            ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                          child: Text("Upcoming Ride",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontFamily: 'SFPro',
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Row(
                        children: <Widget>[
                          Text('Ride Info', style: TextStyle(color: Colors.grey[800],
                              fontSize: 20,
                              fontFamily: 'SFPro',
                              fontWeight: FontWeight.bold)),
                          SizedBox(width: 10.0),
                          Text('Confirmed',
                              style: TextStyle(color: Colors.green[500], fontSize: 11))
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 20),
                          rideTimeLine(),
                          SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  informationRow('Upson Hall', '124 Hoy Rd, Ithaca, NY 14850', 'Pickup Passenger 1', '3:15 PM'),
                                  SizedBox(height: 20),
                                  informationRow('Gates Hall', '107 Hoy Rd, Ithaca, NY 14853', 'Pickup Passenger 2', '3:20 PM'),
                                  SizedBox(height: 20),
                                  informationRow('Statler Hall', '109 Tower Rd, Ithaca, NY 14850', 'Dropoff Passenger 1', '3:25 PM'),
                                  SizedBox(height: 20),
                                  informationRow('Rhodes Hall', '109 Tower Rd, Ithaca, NY 14850', 'Dropoff Passenger 2', '4:20 PM'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 20)
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 4,
                      color: Colors.grey[200],
                    ),
                    SizedBox(height: 15),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.account_circle, size: 50),
                          SizedBox(width: 15),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Davea Butler', style: TextStyle(color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'SFPro')),
                                SizedBox(height: 5),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.phone, size: 15),
                                      SizedBox(width: 7),
                                      Text('+1 323-231-5234', style: TextStyle(color: Colors.grey[600]))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 4,
                      color: Colors.grey[200],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.not_interested, color: Colors.red),
                        SizedBox(width: 10),
                        Text('Cancel Ride', style: TextStyle(color: Colors.red,
                            fontSize: 18,
                            fontFamily: 'SFPro'))
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/8),
                  ],
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/8,
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width * 0.8,
                        height: 45.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                        child: RaisedButton.icon(
                            onPressed: (){},
                            elevation: 3.0,
                            color: Colors.black,
                            textColor: Colors.white,
                            icon: Icon(Icons.mode_edit),
                            label: Text('Edit Ride')
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
    );
  }

  Widget rideTimeLine() {
    return Container(
      width: 18,
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.only(left: 6),
                        width: 4,
                        height: 200,
                        color: Colors.black,
                      ),
                      locationCircle(),
                      Positioned(
                        top: 60,
                        child: locationCircle(),
                      ),
                      Positioned(
                        top: 120,
                        child: locationCircle(),
                      ),
                      Positioned(
                        top: 182,
                        child: locationCircle(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget locationCircle() {
    return Container(
      width: 18,
      height: 18,
      decoration: new BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
        border: new Border.all(
            color: Colors.white, width: 6.0, style: BorderStyle.solid),
        boxShadow: [
          new BoxShadow(
            color: Colors.grey[900],
            blurRadius: 5.0,
          )
        ],
      ),
    );
  }

  Widget informationRow(String loc, String address, String pickup, String time){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(loc,
                style: TextStyle(color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'SFPro')
            ),
            Text(pickup,
                style: TextStyle(color: Colors.grey,
                    fontSize: 13,
                    fontFamily: 'SFPro')
            ),
          ],
        ),
        SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(address,
                style: TextStyle(color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'SFPro')
            ),
            Text(time,
                style: TextStyle(color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'SFPro')
            )
          ],
        )
      ],
    );
  }
}

