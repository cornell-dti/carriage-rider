import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  ToggleButton(this.selected, this.toggle, this.text, this.semanticLabel);
  final bool selected;
  final Function toggle;
  final String text;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0.0,
      onPressed: toggle,
      constraints: BoxConstraints.tightFor(
        width: 50.0,
        height: 50.0,
      ),
      shape: CircleBorder(side: BorderSide(color: Colors.grey)),
      fillColor: selected ? Colors.black : Colors.white,
      child: Semantics(
        checked: selected,
        child: Text(
          text,
          semanticsLabel: semanticLabel,
          style: selected
              ? TextStyle(color: Colors.white, fontSize: 18)
              : TextStyle(color: Colors.grey, fontSize: 18),
        ),
      ),
    );
  }
}
