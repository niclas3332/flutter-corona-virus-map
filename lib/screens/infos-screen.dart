import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void initState() {
    super.initState();
    analytics.setCurrentScreen(screenName: "/screens/infoScreen");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
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
