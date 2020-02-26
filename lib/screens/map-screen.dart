import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:coronamaps/keys.dart';
import 'package:coronamaps/providers/has-premium.dart';
import 'package:coronamaps/providers/map-provider.dart';
import 'package:coronamaps/providers/world-provider.dart';
import 'package:coronamaps/widgets/city-overlay-widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  bool _isError = false;
  bool _isLoading = true;

  _fetchMap() {
    setState(() {
      _isError = false;
      _isLoading = true;
    });

    print("Load Corona Map Data");

    Provider.of<MapProvider>(context, listen: false)
        .fetchOnline()
        .whenComplete(() {
      _fetchWorldData();
      setState(() {
        _isLoading = false;
      });
    }).catchError((_) {
      setState(() {
        _isLoading = false;
        _isError = true;
        print("Error true");
      });
    });
  }

  _fetchWorldData() {
    print("Load Corona World Data");

    Provider.of<WorldProvider>(context, listen: false)
        .fetchData()
        .catchError((_) {
      print("Error");
    }).then((_) {
      setState(() {});
    });
  }

  @override
  void initState() {
    _fetchMap();

    Provider.of<HasPremium>(context, listen: false).checkPremium();

    super.initState();
  }

  int key = 0;

  @override
  Widget build(BuildContext context) {
    var _circles = Provider.of<MapProvider>(
      context,
    ).circles;

    var _circleData = Provider.of<MapProvider>(
      context,
    ).circleData;

    var circles = Map<CircleId, Circle>();
    var widget = CityOverlayWidget();

    _circles.values.forEach((f) {
      circles[f.circleId] = Circle(
          circleId: f.circleId,
          center: f.center,
          consumeTapEvents: true,
          fillColor: f.fillColor,
          strokeColor: f.strokeColor,
          radius: f.radius,
          strokeWidth: f.strokeWidth,
          visible: f.visible,
          zIndex: f.zIndex,
          onTap: () {
            print("Optapped " + _circleData[f.circleId].country);
            widget.insertOverlayCity(
                context,
                _circleData[f.circleId].recovered,
                _circleData[f.circleId].confirmed,
                _circleData[f.circleId].deaths,
                _circleData[f.circleId].country,
                _circleData[f.circleId].lastUpdate,
                key,
                analytics);
          });
    });

    var worldData = Provider.of<WorldProvider>(context);

    if (_isLoading) return Center(child: CircularProgressIndicator());

    if (_isError)
      return RefreshIndicator(
        onRefresh: () => _fetchMap(),
        child: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        contentPadding:
                            EdgeInsets.only(left: 10, right: 10, top: 20),
                        leading: Icon(Icons.error),
                        title: Text('An error occurred'),
                        subtitle: Text(
                            'We couldn\'t fetch the corona virus data from our Firebase server. Please check your internet connection or contact our customer support.'),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('TRY AGAIN'),
                            onPressed: () {
                              _fetchMap();
                            },
                          ),
                          FlatButton(
                            child: const Text('CONTACT US'),
                            onPressed: () {
                              launch(
                                  ("mailto:apps@niclas.xyz?subject=Corona%20Map%20App:%20Fetch%20Map%20no%20connection"));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

    final screen = MediaQuery.of(context).size;

    bool isX = (screen.height >= 896.0) && Platform.isIOS;

    return Container(
      color: Colors.green,
      child: Column(
        children: <Widget>[
          Container(
            height: AppBar().preferredSize.height * 1.1,
            color: Colors.green,
            padding: EdgeInsets.only(left: 25, right: 25, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "CONFIRMED",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      worldData.confirmed.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "DEATHS",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      worldData.deaths.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "RECOVERED",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      worldData.recovered.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(31.4153594, 97.3556841),
                  zoom: 3.0,
                ),
                circles: Set<Circle>.of(circles.values),
              ),
            ),
          ),
          Consumer<HasPremium>(builder: (BuildContext ctx, consumer, _) {
            if (!consumer.hasPremium)
              return Column(
                children: <Widget>[
                  AdmobBanner(
                    adUnitId: Platform.isIOS ? Keys.adUnitIdiOS : Keys.adUnitId,
                    adSize: AdmobBannerSize.FULL_BANNER,
                  ),
                  isX ? SizedBox(height: 25) : Container()
                ],
              );
            else
              return Container();
          }),
        ],
      ),
    );
  }
}
