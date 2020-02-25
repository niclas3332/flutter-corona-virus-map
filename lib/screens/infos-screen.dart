import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Text(
        "This feature will be added in a coming update.",
        style: TextStyle(
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      )),
    );
  }
}
