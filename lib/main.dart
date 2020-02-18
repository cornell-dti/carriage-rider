import 'package:flutter/material.dart';

void main () => runApp(MaterialApp(
  home: Home(),
  debugShowCheckedModeBanner: false,
));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final subHeadingStyle = TextStyle(
        color: Colors.grey[700],
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        fontSize: 20,
        height: 2
    );

    final directionStyle = TextStyle(
        color: Colors.grey[500],
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        fontSize: 12,
        height: 2
    );

    final infoStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        fontSize: 18,
        height: 2
    );

    final monthStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        fontSize: 18,
        height: 2
    );

    final dayStyle = TextStyle(
        color: Colors.grey[700],
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        fontSize: 18,
        height: 2
    );

    final timeStyle = TextStyle(
        color: Colors.grey[500],
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        fontSize: 17,
        height: 2
    );

    final confirmationStyle = TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        fontSize: 12,
        height: 2
    );


    return Scaffold(
      endDrawer: Drawer(),
      appBar: AppBar(
        title: Text(
          'Hi Aiden!', style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          //subheading Next Ride
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 17.0, bottom: 15.0),
            child: Text('Next Ride', style: subHeadingStyle,
            ),
          ),
          //start of Current Ride Card
          Container(
            margin: EdgeInsets.only(left: 17.0, right: 17.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),boxShadow: [
              BoxShadow(color: Colors.grey[500], blurRadius: 3.0)
            ],
                color: Colors.white
            ),
            padding: EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 84.2, right: 84.22),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(3.0),
                          topRight: Radius.circular(3.0)
                      )
                  ),
                  child: Text('Your driver will arrive in 2 mintues', style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  margin: EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('From', style: directionStyle),
                          Text('Upson Hall', style: infoStyle,)
                        ],
                      ),
                      Icon(Icons.arrow_forward),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('To', style: directionStyle),
                          Text('Uris Hall', style: infoStyle,)
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 50.0, top:7.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Icon(Icons.person_pin, size: 38.0),
                      ),
                      SizedBox(width: 5.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Davea Butler', style: infoStyle),
                          Row(
                            children: <Widget>[
                              Icon(Icons.phone, size: 13.0,),
                              SizedBox(width: 5.0),
                              Text('+ 323-231-5234')
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          //end of Current Ride card
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 17.0, bottom: 15.0),
            child: Text('Upcoming Rides', style: subHeadingStyle,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 17.0),
            height: 260.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 15.0),
                  width: 260.0,
                  height: 300.0,
                  child: Card(
                    elevation: 3.0,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 2.0),
                                child: Text('OCT', style: monthStyle),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 2.0, top: 1.0),
                                child: Text('18th', style: dayStyle),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 2.0, top: 3.0),
                                child: Text('12:00 PM', style: timeStyle),
                              ),
                              Padding(
                                padding:  const EdgeInsets.only(left: 44.0),
                                child: Icon(Icons.touch_app),
                              )
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('From', style: directionStyle)
                              ],
                            )
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('Uris Hall', style: infoStyle)
                              ],
                            )
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('To', style: directionStyle)
                              ],
                            )
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('Cascadilla Hall', style: infoStyle)
                              ],
                            )
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('Ride Confirmed', style: confirmationStyle)
                              ],
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Icon(Icons.person_pin, size: 38.0),
                              ),
                              SizedBox(width: 5.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('Davea Butler', style: infoStyle),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.phone, size: 13.0,),
                                      SizedBox(width: 5.0),
                                      Text('+ 323-231-5234')
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right:15.0),
                  width: 260.0,
                  height: 300.0,
                  child: Card(
                    elevation: 3.0,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 2.0),
                                child: Text('NOV', style: monthStyle),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 2.0, top: 1.0),
                                child: Text('20th', style: dayStyle),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 2.0, top: 3.0),
                                child: Text('1:00 PM', style: timeStyle),
                              ),
                              Padding(
                                padding:  const EdgeInsets.only(left: 44.0),
                                child: Icon(Icons.touch_app),
                              )
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('From', style: directionStyle)
                              ],
                            )
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('Balch Hall', style: infoStyle)
                              ],
                            )
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('To', style: directionStyle)
                              ],
                            )
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('Statler Hall', style: infoStyle)
                              ],
                            )
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('Ride Confirmed', style: confirmationStyle)
                              ],
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Icon(Icons.person_pin, size: 38.0),
                              ),
                              SizedBox(width: 5.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('George Michael', style: infoStyle),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.phone, size: 13.0,),
                                      SizedBox(width: 5.0),
                                      Text('+ 323-231-5234')
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 17.0, bottom: 15.0),
            child: Text('Ride History', style: subHeadingStyle,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 17.0, right: 17.0, bottom: 15.0),
            width: 200.0,
            height: 125.0,
            child: Card(
              elevation: 3.0,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: Text('OCT', style: monthStyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0, top: 1.0),
                          child: Text('18th', style: dayStyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0, top: 3.0),
                          child: Text('12:00 PM', style: timeStyle),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 11.0),
                              child: Text('From', style: directionStyle),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 11.0),
                              child: Text('Upson Hall', style: infoStyle,),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 70.0),
                          child: Icon(Icons.arrow_forward),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 85.0),
                              child: Text('To', style: directionStyle),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 85.0),
                              child: Text('Uris Hall', style: infoStyle,),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 17.0, right: 17.0, bottom: 15.0),
            width: 200.0,
            height: 125.0,
            child: Card(
              elevation: 3.0,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: Text('FEB', style: monthStyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0, top: 1.0),
                          child: Text('29th', style: dayStyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0, top: 3.0),
                          child: Text('12:00 PM', style: timeStyle),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 11.0),
                              child: Text('From', style: directionStyle),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 11.0),
                              child: Text('White Hall', style: infoStyle,),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 70.0),
                          child: Icon(Icons.arrow_forward),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 85.0),
                              child: Text('To', style: directionStyle),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 85.0),
                              child: Text('Uris Hall', style: infoStyle,),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
