import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  ToggleButton(this.index, this.text, this.values);

  final int index;
  final String text;
  final List<bool> values;

  @override
  _ToggleButtonState createState() => new _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  void _buttonChange() {
    setState(() {
      widget.values[widget.index] = !widget.values[widget.index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0.0,
      child: Text(
        widget.text,
        style: widget.values[widget.index]
            ? TextStyle(color: Colors.white, fontSize: 18)
            : TextStyle(color: Colors.grey, fontSize: 18),
      ),
      onPressed: _buttonChange,
      constraints: BoxConstraints.tightFor(
        width: 50.0,
        height: 50.0,
      ),
      shape: CircleBorder(
        side: BorderSide(color: Colors.grey)
      ),
      fillColor: widget.values[widget.index] ? Colors.black : Colors.white,
    );
  }
}
