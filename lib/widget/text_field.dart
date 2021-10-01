import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField(
      this.labelText, this.hintText, this.isPassword, this.onchanged);
  final String labelText, hintText;
  final bool isPassword;
  final onchanged;
  CustomTextFieldState createState() => new CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: new ThemeData(
        primaryColor: Colors.black87,
      ),
      child: new TextField(
        obscureText: widget.isPassword,
        onChanged: widget.onchanged,
        decoration: new InputDecoration(
          border: OutlineInputBorder(
            borderSide: new BorderSide(
              color: Colors.black,
            ),
          ),
          contentPadding: new EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          labelText: widget.labelText,
          prefixStyle: new TextStyle(
            color: Colors.black,
          ),
          hintText: widget.hintText,
        ),
      ),
    );
  }
}
