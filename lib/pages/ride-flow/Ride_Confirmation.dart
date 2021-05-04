import 'package:carriage_rider/providers/RideFlowProvider.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    RideFlowProvider rideFlowProvider = Provider.of<RideFlowProvider>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: ExcludeSemantics(child: Image(image: AssetImage(rideFlowProvider.editing ? 'assets/images/changesInProgress.png' : 'assets/images/RequestInProgress.png'))),
          ),
          SizedBox(height: 36),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  rideFlowProvider.editing ? 'Your changes are in progress!' : 'Your request is in progress!',
                  style: CarriageTheme.title3
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                      'You\'ll be notified via in-app notification when your ride is confirmed',
                      style: CarriageTheme.body.copyWith(color: CarriageTheme.gray3),
                      textAlign: TextAlign.center
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    height: 50.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      },
                      elevation: 3.0,
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text('Done', style: CarriageTheme.button),
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
