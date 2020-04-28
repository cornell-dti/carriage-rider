import 'package:flutter/material.dart';

class CurrentRide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

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

    return Container(
      margin: EdgeInsets.only(left: 17.0, right: 17.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0), boxShadow: [
        BoxShadow(color: Colors.grey[500], blurRadius: 3.0)
      ],
          color: Colors.white
      ),
      padding: EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 5.0, bottom: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(3.0),
                            topRight: Radius.circular(3.0)
                        )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Your driver will arrive in 2 mintues',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
                  children: <Widget>[
                    Text('To', style: directionStyle),
                    Text('Uris Hall', style: infoStyle,)
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 50.0, top: 7.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Icon(Icons.person_pin, size: 38.0),
                ),
                SizedBox(width: 5.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}
