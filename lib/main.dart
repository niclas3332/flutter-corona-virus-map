import 'package:admob_flutter/admob_flutter.dart';
import 'package:coronamaps/providers/map-provider.dart';
import 'package:coronamaps/providers/news-provider.dart';
import 'package:coronamaps/providers/world-provider.dart';
import 'package:coronamaps/screens/in-app-purchase-screen.dart';
import 'package:coronamaps/screens/infos-screen.dart';
import 'package:coronamaps/screens/map-screen.dart';
import 'package:coronamaps/screens/news-screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/observer.dart';
import 'keys.dart';
import 'providers/has-premium.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

void main() {
  Admob.initialize(Keys.admobAppId);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => MapProvider()),
        ChangeNotifierProvider(create: (ctx) => WorldProvider()),
        ChangeNotifierProvider(create: (ctx) => NewsProvider()),
        ChangeNotifierProvider(create: (ctx) => HasPremium()),
      ],
      child: MaterialApp(
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        title: 'Corona Virus',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Corona Virus Map"),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: "MAP",
                  ),
                  Tab(
                    text: "INFOS",
                  ),
                  Tab(text: "NEWS"),
                  Tab(text: "NO ADS"),
                ],
              ),
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                MapScreen(),
                InfoScreen(),
                NewsScreen(),
                RemoveAdsScreen()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
