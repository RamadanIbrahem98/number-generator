import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  InputField(
      {required this.label,
      required this.placeholder,
      this.preIcon,
      this.postIcon});
  String label;
  String placeholder;
  IconData? preIcon;
  IconData? postIcon;
  @override
  Widget build(BuildContext context) {
    return _build();
  }

  Widget _build() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
          child: Text(
            label,
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
              labelText: placeholder,
            ),
          ),
        )
      ],
    );
  }
}
