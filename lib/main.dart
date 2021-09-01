import 'package:flutter/material.dart';
import 'package:number_generator/app/sign_in/sign_in_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/build/build_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Generator',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    super.initState();
    loginStatus();
  }

  void loginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences?.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Div()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
