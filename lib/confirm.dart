import 'package:flutter/material.dart';

class Confirm extends StatefulWidget {
  final String message;
  final Function onConfirm;

  Confirm({super.key, required this.message, required this.onConfirm});

  @override
  State<Confirm> createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.orange,
      title: Text(
        "Alert",
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
        widget.message,
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "No",
              style: TextStyle(color: Colors.white),
            )),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onConfirm();
            },
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }
}
