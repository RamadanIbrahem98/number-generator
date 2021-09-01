import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:number_generator/app/sign_in/sign_in_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class Div extends StatefulWidget {
  const Div({Key? key}) : super(key: key);
  @override
  _DivState createState() => _DivState();
}

class _DivState extends State<Div> {
  dynamic rand =
      " Press the dice button on the botton right of your screen to generate a list of 1000 numbers ";
  //number generation func
  dynamic generate(int capacity, int limit) {
    return List.generate(capacity, (_) => Random().nextInt(limit + 1))
        .join('  =>  ');
  }

  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    super.initState();
    setSharedPreferences();
  }

  void setSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  sharedPreferences?.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => MainPage()),
                      (Route<dynamic> route) => false);
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(Icons.open_in_new),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
            // The search area here
            title: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          /* Clear the search field */
                        },
                      ),
                      hintText: 'Search number...',
                      border: InputBorder.none),
                ),
              ),
            )),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                          child: Text(
                            'Numbers generated:',
                            style: TextStyle(
                              color: Colors.red[900],
                              fontSize: 50,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 100,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.symmetric(vertical: 20),
                              width: 1500,
                              child: Text(
                                '$rand',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  height: 1.8,
                                  wordSpacing: 15,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              rand = generate(10000, 3000);
            });
          },
          child: Icon(Icons.casino_outlined),
        ));
  }
}
