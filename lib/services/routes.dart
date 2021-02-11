// Packages:
import 'package:flutter/material.dart';

class RoutesHelper {
  //Using an animated transition
  // Creates a route with a previous animated transition into a given destiny:
  Route createRoute({Widget destiny}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destiny,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
