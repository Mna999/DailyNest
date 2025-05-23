import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final bool isPassword;
  final TextEditingController controller;
  final String message;
  const MyTextField(
      {super.key,
      required this.isPassword,
      required this.controller,
      required this.message});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool isVisable = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        cursorColor: Colors.black,
        controller: widget.controller,
        obscureText: widget.isPassword && !isVisable,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(100)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(color: Colors.orange, width: 2)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(color: Colors.orange, width: 2)),
          hintText: widget.message,
          hintStyle: TextStyle(color: Colors.grey),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    isVisable ? Icons.visibility : Icons.visibility_off,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    setState(() {
                      isVisable = !isVisable;
                    });
                  },
                )
              : Icon(Icons.abc, size: 0),
        ));
  }
}
