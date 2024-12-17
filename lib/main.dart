import 'package:coronamaps/providers/map-provider.dart';
import 'package:coronamaps/providers/news-provider.dart';
import 'package:coronamaps/providers/world-provider.dart';
import 'package:coronamaps/screens/map-screen.dart';
import 'package:coronamaps/screens/news-screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



void main() {
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
      ],
      child: MaterialApp(

        title: 'Corona Virus',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Corona Virus Map"),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: "MAP",
                  ),
                
                  Tab(text: "NEWS"),
            
                ],
              ),
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                MapScreen(),
            
                NewsScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
