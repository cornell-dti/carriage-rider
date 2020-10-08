import 'package:carriage_rider/Account_Pronouns.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/AuthProvider.dart';
import 'RiderProvider.dart';
import 'package:provider/provider.dart';
import 'package:carriage_rider/app_config.dart';

class AccountName extends StatefulWidget {
  @override
  _AccountNameState createState() => _AccountNameState();
}

class _AccountNameState extends State<AccountName> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();

  //TextEditingController firstNameCtrl = TextEditingController();
  //TextEditingController lastNameCtrl = TextEditingController();

  final titleStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontSize: 25,
  );

  @override
  Widget build(BuildContext context) {
    RiderProvider riderProvider = Provider.of<RiderProvider>(context);
    AuthProvider authProvider = Provider.of(context);
    String _firstName = riderProvider.info.firstName;
    String _lastName = riderProvider.info.lastName;
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
                    child:
                        Text("How should we address you?", style: titleStyle),
                  )
                ],
              ),
              SizedBox(height: 40.0),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        initialValue: riderProvider.info.firstName,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                        onSaved: (input) {
                          setState(() {
                            _lastName = input;
                          });
                        },
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        onFieldSubmitted: (value) =>
                            FocusScope.of(context).nextFocus()),
                    SizedBox(height: 20.0),
                    TextFormField(
                        initialValue: riderProvider.info.lastName,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                        onSaved: (input) {
                          setState(() {
                            _lastName = input;
                          });
                        },
                        style: TextStyle(color: Colors.black, fontSize: 15)),
                    SizedBox(height: 10.0)
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Row(children: <Widget>[
                Flexible(
                    child: Text(
                        'By continuing, I accept the Terms of Services and Privacy Policies',
                        style:
                            TextStyle(fontSize: 10, color: Colors.grey[500])))
              ]),
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
                              riderProvider.setNames(
                                  AppConfig.of(context),
                                  authProvider,
                                  _firstName,
                                  _lastName);
                              Navigator.pop(context);
                            }
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => AccountPronouns()));
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
        ));
  }
}
