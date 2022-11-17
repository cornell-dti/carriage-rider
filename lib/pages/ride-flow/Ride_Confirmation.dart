import 'package:carriage_rider/providers/RideFlowProvider.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:carriage_rider/widgets/Buttons.dart';
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
            child: ExcludeSemantics(
                child: Image(
                    image: AssetImage(rideFlowProvider.creating()
                        ? 'assets/images/RequestInProgress.png'
                        : 'assets/images/changesInProgress.png'))),
          ),
          SizedBox(height: 36),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                        rideFlowProvider.creating()
                            ? 'Your request is in progress!'
                            : 'Your changes are in progress!',
                        textAlign: TextAlign.center,
                        style: CarriageTheme.title3),
                  ),
                )
              ],
            ),
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
                      style: CarriageTheme.body
                          .copyWith(color: CarriageTheme.gray3),
                      textAlign: TextAlign.center),
                ),
              )
            ],
          ),
          Expanded(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.only(left: 34, right: 34, bottom: 30.0),
                  child: CButton(
                    text: 'Done',
                    height: 50,
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                )),
          )
        ],
      ),
    );
  }
}
