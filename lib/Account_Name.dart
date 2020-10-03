import 'package:carriage_rider/Account_Pronouns.dart';
import 'package:flutter/material.dart';


class AccountName extends StatefulWidget {
  @override
  _AccountNameState createState() => _AccountNameState();
}

class _AccountNameState extends State<AccountName> {

  final _formKey = GlobalKey<FormState>();

  Widget _buildFirstNameField(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'First Name',),
    );
  }

  Widget _buildLastNameField(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Last Name',),
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
                    child: Text("How should we address you?", style: titleStyle),
                  )

                ],
              ),
              SizedBox(height: 40.0),
              Form(
                child: Column(
                  children: <Widget>[
                    _buildFirstNameField(),
                    SizedBox(height: 20.0),
                    _buildLastNameField(),
                    SizedBox(height: 10.0)
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Row(children: <Widget>[
                Flexible(
                  child: Text('By continuing, I accept the Terms of Services and Privacy Policies', style: TextStyle(fontSize: 10, color: Colors.grey[500]))
                )
              ]),
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
                            Navigator.push(context, new MaterialPageRoute(builder: (context) => AccountPronouns()));
                          },
                          elevation: 3.0,
                          color: Colors.black,
                          textColor: Colors.white,
                          child: Text('Next'),
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
