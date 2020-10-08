import 'package:flutter/material.dart';
import 'package:carriage_rider/Home.dart';
import 'package:carriage_rider/AuthProvider.dart';
import 'RiderProvider.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/app_config.dart';

class AccountNumber extends StatefulWidget {
  @override
  _AccountNumberState createState() => _AccountNumberState();
}

class _AccountNumberState extends State<AccountNumber> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  TextEditingController phoneCtrl = TextEditingController();

  Widget _buildPhoneNumberField() {
    return TextFormField(
      controller: phoneCtrl,
      focusNode: focusNode,
      decoration: InputDecoration(
          labelText: 'Phone Number',
          labelStyle: TextStyle(color: Colors.black)),
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter your phone number';
        }
        return null;
      },
      style: TextStyle(color: Colors.black, fontSize: 15),
    );
  }

  final titleStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontSize: 25,
  );

  @override
  Widget build(BuildContext context) {
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    AuthProvider authProvider = Provider.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                key: _formKey,
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              riderProvider.setPhone(
                                  AppConfig.of(context),
                                  authProvider,
                                  phoneCtrl.text);
                              Navigator.pop(context);
                            }
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => Home()));
                          },
                          elevation: 3.0,
                          color: Colors.black,
                          textColor: Colors.white,
                          child: Text('Done'),
                        ),
                      ),
                    )),
              )
            ],
          ),
        ));
  }
}
