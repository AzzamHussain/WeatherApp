import 'package:flutter/material.dart';
import 'package:weatherapp/UI/GetStarted.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Application',
      home: GetStarted(),
      debugShowCheckedModeBanner: false,
    );
  }
}
