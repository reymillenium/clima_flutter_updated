// Packages:
import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  // Properties:
  final Color color;
  final Widget cardChild;
  final VoidCallback onTapEvent;

  // Constructor
  ReusableCard({@required this.color, this.cardChild, this.onTapEvent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapEvent,
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(child: cardChild),
      ),
    );
  }
}
