import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField(
      this.labelText, this.hintText, this.isPassword, this.onchanged,
      {this.initialValue});
  final String labelText, hintText, initialValue;
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
      child: new TextFormField(
        initialValue: widget.initialValue,
        obscureText: widget.isPassword,
        onChanged: widget.onchanged,
        decoration: new InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
            borderSide: new BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          contentPadding: new EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10,
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
