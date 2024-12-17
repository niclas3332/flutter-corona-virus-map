
import 'package:coronamaps/providers/map-provider.dart';
import 'package:coronamaps/providers/world-provider.dart';
import 'package:coronamaps/widgets/city-overlay-widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //FirebaseAnalytics analytics = //FirebaseAnalytics();



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
    }).catchError((err) {
      //analytics.logEvent(name: "catchError_mapProvider");

      setState(() {
        _isLoading = false;
        _isError = true;
        print("Error true");
        print(err.toString());
    
      });
    });
  }

  _fetchWorldData() {
    print("Load Corona World Data");

    Provider.of<WorldProvider>(context, listen: false)
        .fetchData()
        .catchError((err) {
      //analytics.logEvent(name: "catchError_worldProvider");

      print("Error");
  
    }).then((_) {
      setState(() {});
    });
  }

  @override
  void initState() {
    _fetchMap();


    super.initState();
  


  }

  int key = 0;

  @override
  Widget build(BuildContext context) {
    var circles0 = Provider.of<MapProvider>(
      context,
    ).circles;

    var circleData = Provider.of<MapProvider>(
      context,
    ).circleData;

    var circles = <CircleId, Circle>{};
    var widget = CityOverlayWidget();

    for (var f in circles0.values) {
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
            print("Optapped " + circleData[f.circleId]!.country);
            widget.insertOverlayCity(
                context,
                circleData[f.circleId]!.recovered,
                circleData[f.circleId]!.confirmed,
                circleData[f.circleId]!.deaths,
                circleData[f.circleId]!.country,
                circleData[f.circleId]!.lastUpdate,
                key);
          });
    }

    var worldData = Provider.of<WorldProvider>(context);

    if (_isLoading){ return Center(child: CircularProgressIndicator());}

    if (_isError){
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
                          TextButton(
                            child: const Text('TRY AGAIN'),
                            onPressed: () {
                              _fetchMap();
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
      );}

final formatter = NumberFormat();


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
                      formatter.format(worldData.confirmed),
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
                      formatter.format(worldData.deaths),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
            
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(31.4153594, 97.3556841),
                zoom: 3.0,
              ),
              circles: Set<Circle>.of(circles.values),
            ),
          ),
      
        ],
      ),
    );

 
  }
}
