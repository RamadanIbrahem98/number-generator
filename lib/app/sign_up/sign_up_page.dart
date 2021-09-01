import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:number_generator/app/sign_in/sign_in_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../validators.dart';

class Signup extends StatefulWidget with EmailAndPasswordValidator {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _fname => _fnameController.text;
  String get _lname => _lnameController.text;
  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  bool _isLoading = false;

  void _validateAndSignUp() async {
    _isLoading = true;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse;
    Map<String, String> headers = {
      "accept": "application/json",
      'Content-Type': 'application/json'
    };
    final data = jsonEncode({
      "fname": _fname,
      "lname": _lname,
      "email": _email,
      "password": _password
    });
    print(data);
    final endPoint =
        Uri.parse("https://my-number-generator.herokuapp.com/signup");
    final response = await http.post(endPoint, body: data, headers: headers);

    switch (response.statusCode) {
      case 200:
        jsonResponse = json.decode(response.body);
        print(jsonResponse);
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
              jsonResponse['payload']['fname'] +
                  jsonResponse['payload']['lname']);
          sharedPreferences.setString(
              "email", jsonResponse['payload']['email']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => Login()),
              (Route<dynamic> route) => false);
        } else {
          setState(() {});
          print("The error message is: ${response.body}");
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isValid = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        widget.textFieldValidator.isValid(_fname) &&
        widget.textFieldValidator.isValid(_lname);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Text(
                                'Fill in the following info: ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 30),
                              child: Text(
                                'First Name',
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
                                    Icons.info,
                                    size: 20,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  labelText: 'Enter Your first name',
                                  errorText:
                                      widget.textFieldValidator.isValid(_fname)
                                          ? null
                                          : widget.textFieldInValidMessage,
                                ),
                                controller: _fnameController,
                                onChanged: (fname) {
                                  setState(() {});
                                },
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 30),
                              child: Text(
                                'Last Name',
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
                                    Icons.info,
                                    size: 20,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  labelText: 'Enter Your last name',
                                  errorText:
                                      widget.textFieldValidator.isValid(_lname)
                                          ? null
                                          : widget.textFieldInValidMessage,
                                ),
                                controller: _lnameController,
                                onChanged: (lname) {
                                  setState(() {});
                                },
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 30),
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
                                // style: ,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.mail,
                                    size: 20,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  labelText: 'Enter Your E-mail',
                                  errorText:
                                      widget.emailValidator.isValid(_email)
                                          ? null
                                          : widget.emailInValidMessage,
                                ),
                                controller: _emailController,
                                onChanged: (email) {
                                  setState(() {});
                                },
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 30),
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
                                  errorText:
                                      widget.passwordValidator.isValid(_email)
                                          ? null
                                          : widget.passwordInValidMessage,
                                ),
                                controller: _passwordController,
                                onChanged: (password) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 15),
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
                                    onPressed:
                                        _isValid ? _validateAndSignUp : null,
                                    // () {
                                    //   Navigator.pop(context);
                                    // },
                                    label: Text(
                                      'Sign Up',
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
                ),
              ],
            ),
    );
  }
}
