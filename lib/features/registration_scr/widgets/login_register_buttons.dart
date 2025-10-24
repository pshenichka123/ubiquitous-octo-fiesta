import 'package:flutter/material.dart';

class ToggleText extends StatefulWidget {
  final String firstText;
  final String secondText;
  final Function(bool isFirstSelected) onToggle;

  const ToggleText({
    Key? key,
    required this.firstText,
    required this.secondText,
    required this.onToggle,
  }) : super(key: key);

  @override
  _ToggleTextState createState() => _ToggleTextState();
}

class _ToggleTextState extends State<ToggleText> {
  bool isFirstFilled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isFirstFilled = true;
            });
            widget.onToggle(true);
          },
          child: Text(
            widget.firstText,
            style: TextStyle(
              fontSize: 24,
              color: !isFirstFilled ? Colors.grey[600] : Colors.white,
              decorationThickness: 2.5,
              fontWeight: !isFirstFilled ? FontWeight.w400 : FontWeight.w900,

              height: 1.2,
            ),
          ),
        ),
        SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            setState(() {
              isFirstFilled = false;
            });
            widget.onToggle(false);
          },
          child: Text(
            widget.secondText,
            style: TextStyle(
              fontSize: 24,
              color: isFirstFilled ? Colors.grey[600] : Colors.white,
              decorationThickness: 2.5,
              fontWeight: isFirstFilled ? FontWeight.w900 : FontWeight.w400,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
