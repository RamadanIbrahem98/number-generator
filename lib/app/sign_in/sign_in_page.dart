import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:number_generator/app/sign_up/sign_up_page.dart';
import 'package:number_generator/app/build/build_page.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  void _validateAndSignIn() async {
    Map<String, String> headers = {
      "accept": "application/json",
      'Content-Type': 'application/json'
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse;
    final data = jsonEncode({'email': _email, 'password': _password});
    final endPoint = Uri.parse("http://localhost:3000/login");
    final response = await http.post(endPoint, body: data, headers: headers);
    print("StatusCode ${response.statusCode}");
    switch (response.statusCode) {
      case 200:
        jsonResponse = json.decode(response.body);
        if (jsonResponse != null) {
          setState(() {
            _isLoading = false;
          });
          sharedPreferences.setString(
              "token", jsonResponse['payload']['password']);
          sharedPreferences.setString(
              "id", jsonResponse['payload']['id'].toString());
          sharedPreferences.setString(
              "username",
              jsonResponse['payload']['lname'] +
                  ' ' +
                  jsonResponse['payload']['lname']);
          sharedPreferences.setString(
              "email", jsonResponse['payload']['email']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => Div()),
              (Route<dynamic> route) => false);
        } else {
          setState(() {
            _isLoading = false;
          });
          print("The error message is: ${response.body}");
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Number Generator',
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Log In',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                          child: Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.indigoAccent,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail,
                                size: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: 'Enter Your E-mail',
                            ),
                            controller: _emailController,
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                          child: Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.indigoAccent,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_rounded),
                              suffixIcon: Icon(
                                Icons.visibility,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: 'Enter Your password',
                            ),
                            controller: _passwordController,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 22),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 0),
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.login_rounded),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                onPressed: _validateAndSignIn,
                                // () {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => Div()),
                                //   );
                                // },
                                label: Text(
                                  'Sign-in',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Center(
                            child: Text(
                              'OR',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 22),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 0),
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.app_registration_rounded),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Signup()),
                                  );
                                },
                                label: Text(
                                  'Sign-Up',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
