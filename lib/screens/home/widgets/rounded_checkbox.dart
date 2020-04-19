import 'package:flutter/material.dart';

class RoundedCheckbox extends StatefulWidget {
  const RoundedCheckbox({@required this.initialValue, this.onTap});

  /// The first state of the checkbox.
  final bool initialValue;

  /// A function that is called when the checkbox is tapped in addition to the
  /// normal state change for the box.
  final void Function(bool) onTap;

  @override
  RoundedCheckboxState createState() => RoundedCheckboxState();
}

class RoundedCheckboxState extends State<RoundedCheckbox> {
  bool value = false;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      final newState = !value;
      widget.onTap(newState);
      setState(() {
        value = newState;
      });
    },
    child: SizedBox(
      height: 28,
      width: 28,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.white
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: value ? Container(
            padding: EdgeInsets.all(3),
            child: Image.asset('img/icon-only.png'),
          ) : Container(),
      ),
    ),
  );
}