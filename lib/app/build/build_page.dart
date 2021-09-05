import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../validators.dart';

class Div extends StatefulWidget with UserNumberInput {
  Div({Key? key}) : super(key: key);
  @override
  _DivState createState() => _DivState();
}

class _DivState extends State<Div> {
  List _generatedNumbers = [];
  bool _generatedAtLeastOnce = false;

  dynamic rand =
      " Press the dice button on the botton right of your screen to generate a list of 1000 numbers ";
  //number generation func
  dynamic generate(int capacity, int limit) {
    _generatedNumbers =
        List.generate(capacity, (_) => Random().nextInt(limit + 1));
    return _generatedNumbers.join('  =>  ');
  }

  SharedPreferences? sharedPreferences;

  final TextEditingController _inputController = TextEditingController();

  String get _input => _inputController.text;

  @override
  void initState() {
    super.initState();
    setSharedPreferences();
  }

  void setSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void _search(String text) {
    final num = int.parse(text);
    final val = _generatedNumbers.where((el) => (el == num));
    if (val.length >= 1) {
      print('yes');
    } else {
      print('no');
    }
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
                  enabled: _generatedAtLeastOnce,
                  decoration: InputDecoration(
                    // contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    // errorText: widget.inputValidator.isValid(_input)
                    //     ? null
                    //     : widget.inputInvalidMessage,
                    // errorStyle: ,
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: _inputController.clear,
                    ),
                    hintText: 'Search number...',
                    border: InputBorder.none,
                  ),
                  controller: _inputController,
                  onSubmitted: (text) =>
                      _input.isNotEmpty && widget.inputValidator.isValid(_input)
                          ? _search(text)
                          : null,
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
                              // padding: EdgeInsets.all(5),
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
                          ),
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
              _generatedAtLeastOnce = true;
            });
          },
          child: Icon(Icons.casino_outlined),
        ));
  }
}
