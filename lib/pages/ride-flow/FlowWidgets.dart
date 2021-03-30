import 'package:flutter/material.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';

TextEditingController fromCtrl = TextEditingController();
TextEditingController toCtrl = TextEditingController();

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class FlowCancel extends StatelessWidget {
  const FlowCancel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: InkWell(
            child: Text('Cancel', style: CarriageTheme.cancelStyle),
            onTap: () {
              fromCtrl.clear();
              toCtrl.clear();
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
        ),
      ],
    );
  }
}

class BackText extends StatelessWidget {
  const BackText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: InkWell(
            child: Text('Back', style: CarriageTheme.cancelStyle),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}

class SelectionButton extends StatelessWidget {
  final Widget page;
  final String text;
  final GestureTapCallback onPressed;

  const SelectionButton({Key key, this.page, this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width * 0.4,
        height: 50.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
                context, new MaterialPageRoute(builder: (context) => page));
          },
          elevation: 3.0,
          color: Colors.white,
          textColor: Colors.black,
          child: Text(text,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class FlowBack extends StatelessWidget {
  const FlowBack({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Row(
                children: <Widget>[
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width * 0.1,
                    height: 50.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      elevation: 2.0,
                      color: Colors.white,
                      child: Row(
                        children: [
                          SizedBox(width: 5),
                          Icon(Icons.arrow_back_ios),
                        ],
                      )
                    ),
                  ),
                ],
              ))),
    );
  }
}

class FlowBackDuo extends StatelessWidget {
  const FlowBackDuo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width * 0.1,
      height: 50.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        elevation: 2.0,
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(width: 5),
            Icon(Icons.arrow_back_ios),
          ],
        )
      ),
    );
  }
}

class TabBarTop extends StatelessWidget {
  final Color colorOne;
  final Color colorTwo;
  final Color colorThree;

  TabBarTop({Key key, this.colorOne, this.colorTwo, this.colorThree})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0),
              child: Divider(
                color: colorOne,
                height: 50,
                thickness: 5,
              )),
        ),
        Expanded(
          child: new Container(
              child: Divider(
            color: colorTwo,
            height: 50,
            thickness: 5,
          )),
        ),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(right: 10.0),
              child: Divider(
                color: colorThree,
                height: 50,
                thickness: 5,
              )),
        ),
      ],
    );
  }
}

class TabBarBot extends StatelessWidget {
  final Color colorOne;
  final Color colorTwo;
  final Color colorThree;

  TabBarBot({Key key, this.colorOne, this.colorTwo, this.colorThree})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: new Container(
            transform: Matrix4.translationValues(0.0, -15.0, 0.0),
            margin: const EdgeInsets.only(left: 10.0),
            child: Icon(Icons.location_on_outlined, color: colorOne, size: 30),
          ),
        ),
        Expanded(
          child: new Container(
            transform: Matrix4.translationValues(0.0, -15.0, 0.0),
            child: Icon(Icons.web_asset, color: colorTwo, size: 30),
          ),
        ),
        Expanded(
          child: new Container(
            transform: Matrix4.translationValues(0.0, -15.0, 0.0),
            margin: const EdgeInsets.only(right: 10.0),
            child: Icon(Icons.check, color: colorThree, size: 30),
          ),
        ),
      ],
    );
  }
}
