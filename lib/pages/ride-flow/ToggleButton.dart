import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  ToggleButton(this.index, this.text, this.values);

  final int index;
  final String text;
  final List<bool> values;

  void _buttonChange() {
    values[index] = values[index];
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0.0,
      child: Text(
        text,
        style: values[index]
            ? TextStyle(color: Colors.white, fontSize: 18)
            : TextStyle(color: Colors.grey, fontSize: 18),
      ),
      onPressed: _buttonChange,
      constraints: BoxConstraints.tightFor(
        width: 50.0,
        height: 50.0,
      ),
      shape: CircleBorder(side: BorderSide(color: Colors.grey)),
      fillColor: values[index] ? Colors.black : Colors.white,
    );
  }
}
