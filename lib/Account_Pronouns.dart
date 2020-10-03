import 'package:carriage_rider/Account_Number.dart';
import 'package:flutter/material.dart';

class AccountPronouns extends StatefulWidget {
  @override
  _AccountPronounsState createState() => _AccountPronounsState();
}

class _AccountPronounsState extends State<AccountPronouns> {
  int selectedRadio = 0;

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  final cancelStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w100,
    fontSize: 15,
  );

  final titleStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w800,
    fontSize: 25,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 60.0),
            Row(
              children: <Widget>[
                Flexible(child: Text("Share your pronouns", style: titleStyle))
              ],
            ),
            SizedBox(height: 15.0),
            Row(children: <Widget>[
              Flexible(
                  child: Text(
                      "Help us get better at addressing you by selecting your pronouns",
                      style: TextStyle(fontSize: 15, color: Colors.grey)))
            ]),
            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RadioListTile(
                  title: Text("They/Them/Theirs"),
                  value: 1,
                  groupValue: selectedRadio,
                  activeColor: Colors.black,
                  onChanged: (val) {
                    setSelectedRadio(val);
                  },
                ),
                RadioListTile(
                  title: Text("She/Her/Hers"),
                  value: 2,
                  groupValue: selectedRadio,
                  activeColor: Colors.black,
                  onChanged: (val) {
                    setSelectedRadio(val);
                  },
                ),
                RadioListTile(
                  title: Text("He/Him/His"),
                  value: 3,
                  groupValue: selectedRadio,
                  activeColor: Colors.black,
                  onChanged: (val) {
                    setSelectedRadio(val);
                  },
                ),
                RadioListTile(
                  title: Text("Others"),
                  value: 4,
                  groupValue: selectedRadio,
                  activeColor: Colors.black,
                  onChanged: (val) {
                    setSelectedRadio(val);
                  },
                ),
                RadioListTile(
                  title: Text("Prefer not to say"),
                  value: 5,
                  groupValue: selectedRadio,
                  activeColor: Colors.black,
                  onChanged: (val) {
                    setSelectedRadio(val);
                  },
                ),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3)),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => AccountNumber()));
                        },
                        elevation: 3.0,
                        color: Colors.black,
                        textColor: Colors.white,
                        child: Text('Next'),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
