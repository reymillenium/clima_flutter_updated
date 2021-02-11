// Packages:
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TransitionSpinner extends StatelessWidget {
  const TransitionSpinner({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitDualRing(
      color: Colors.white,
      size: 100.0,
      // duration: Duration(milliseconds: 3000),
    );
  }
}
