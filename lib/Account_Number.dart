import 'package:flutter/material.dart';
import 'package:carriage_rider/Home.dart';

class AccountNumber extends StatefulWidget {
  @override
  _AccountNumberState createState() => _AccountNumberState();
}

class _AccountNumberState extends State<AccountNumber> {

  final _formKey = GlobalKey<FormState>();

  Widget _buildPhoneNumberField(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Phone Number',),
    );
  }

  final titleStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontSize: 25,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 50.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text("And your phone number?", style: titleStyle),
                  )

                ],
              ),
              SizedBox(height: 40.0),
              Form(
                child: Column(
                  children: <Widget>[
                    _buildPhoneNumberField(),
                    SizedBox(height: 10.0)
                  ],
                ),
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
                            Navigator.push(context, new MaterialPageRoute(builder: (context) => Home()));
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
        )
    );

  }
}
