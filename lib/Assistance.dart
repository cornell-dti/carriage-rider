import 'package:flutter/material.dart';
import 'package:carriage_rider/Repeat_Ride.dart';

class Assistance extends StatefulWidget {

  @override
  _AssistanceState createState() => _AssistanceState();

}

class _AssistanceState extends State<Assistance> {

  int selectedRadio = 0;

  setSelectedRadio(int val){
    setState(() {
      selectedRadio = val;
    });
  }


  final cancelStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w100,
    fontSize: 15,
  );

  final questionStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w800,
    fontSize: 25,
  );

  final toggleStyle = TextStyle(
    fontWeight: FontWeight.w200,
    fontSize: 18,
  );

  final descriptionStyle = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w100,
      fontSize: 13
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: InkWell(
                    child: Text("Cancel", style: cancelStyle),
                    onTap: () {
                      Navigator.pop(context, new MaterialPageRoute(builder: (context) => RepeatRide()));
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.brightness_1, size: 12.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.brightness_1, size: 12.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.brightness_1, size: 12.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.group_work),
                ),
                Icon(Icons.brightness_1, color: Colors.grey[350], size: 12.0),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Flexible(child: Text("Do you need any assistance? (optional)", style: questionStyle))
              ],
            ),
            SizedBox(height: 40),
            RadioListTile(
              title: Text("Wheelchair"),
              value: 1,
              groupValue: selectedRadio,
              activeColor: Colors.black,
              onChanged: (val){
                setSelectedRadio(val);
              },
            ),
            RadioListTile(
              title: Text("Other"),
              value: 2,
              groupValue: selectedRadio,
              activeColor: Colors.black,
              onChanged: (val){
                setSelectedRadio(val);
              },
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
                        child: Text('Review'),
                      ),
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );

  }
}
