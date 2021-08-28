import 'package:flutter/material.dart';
import 'package:number_generator/app/sign_in/sign_in_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Generator',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Login(),
    );
  }
}
