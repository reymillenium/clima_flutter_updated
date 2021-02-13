// Packages:
import 'package:flutter/material.dart';

// Screens:
import 'package:clima/screens/loading_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima',
      theme: ThemeData.dark().copyWith(
        textSelectionColor: Colors.lightBlue.shade50,
      ),
      home: LoadingScreen(title: 'Clima'),
    );
  }
}
