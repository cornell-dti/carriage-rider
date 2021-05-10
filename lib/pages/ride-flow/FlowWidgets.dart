import 'package:carriage_rider/providers/RideFlowProvider.dart';
import 'package:flutter/material.dart';
import 'package:carriage_rider/utils/CarriageTheme.dart';
import 'package:provider/provider.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class FlowCancel extends StatelessWidget {
  const FlowCancel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RideFlowProvider rideFlowProvider = Provider.of<RideFlowProvider>(context);

    void onTap() {
      rideFlowProvider.clearControllers();
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Semantics(
          button: true,
          label: 'Cancel',
          onTap: onTap,
          child: Container(
            height: 48,
            child: ExcludeSemantics(
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(child: Text('Cancel', style: CarriageTheme.cancelStyle)),
                ),
                onTap: onTap,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class BackText extends StatelessWidget {
  const BackText({Key key}) : super(key: key);

  void onTap(context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Semantics(
          button: true,
          label: 'Back',
          onTap: () => onTap(context),
          child: Container(
            height: 48,
            child: ExcludeSemantics(
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(child: Text('Back', style: CarriageTheme.cancelStyle)),
                ),
                onTap: () => onTap(context),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class SelectionButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final GestureTapCallback onPressed;

  const SelectionButton({Key key, @required this.text, @required this.width, @required this.height, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: text,
      onTap: onPressed,
      child: ExcludeSemantics(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurRadius: 1,
                    spreadRadius: 0,
                    color: Colors.black.withOpacity(0.25)
                )
              ],
              borderRadius: BorderRadius.circular(12)
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onTap: onPressed,
              child: Center(
                child: Text(text,
                    style: CarriageTheme.button.copyWith(color: Colors.black)
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}

class BackArrowButton extends StatelessWidget {
  final double size;
  BackArrowButton(this.size);
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      onTap: () => Navigator.pop(context),
      child: ExcludeSemantics(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [CarriageTheme.boxShadow],
              borderRadius: BorderRadius.circular(12)
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onTap: () => Navigator.pop(context),
              child: Semantics(
                label: 'Back',
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.arrow_back_ios),
                ),
              ),
            ),
          ),
        ),
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
