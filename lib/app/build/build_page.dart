import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
    var list = List.generate(capacity, (_) => Random().nextInt(limit + 1));

    return list.join('  =>  ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                        Container(
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
            rand = generate(1000, 3000);
          });
        },
        child: Icon(Icons.casino_outlined),
      ),
    );
  }
}
