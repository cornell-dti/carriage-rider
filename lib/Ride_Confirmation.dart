import 'package:flutter/material.dart';

class RideConfirmation extends StatefulWidget {
  @override
  _RideConfirmationState createState() => _RideConfirmationState();
}

class _RideConfirmationState extends State<RideConfirmation> {

  final requestStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w700,
    fontSize: 17,
  );

  final descriptionStyle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.w300,
    fontSize: 15,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height*0.2),
          Image(
            image: AssetImage('assets/images/RequestInProgress.png')
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Your request is in progress!', style: requestStyle)
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You\'ll be notified via in-app notification', style: descriptionStyle)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('and email when your ride is confirmed', style: descriptionStyle)
            ],
          ),
          Expanded(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    height: 45.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                    child: RaisedButton(
                      onPressed: (){
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      },
                      elevation: 3.0,
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text('Done'),
                    ),
                  ),
                )
            ),
          )
        ],
      ),
    );
  }
}
