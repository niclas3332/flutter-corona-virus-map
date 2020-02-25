import 'dart:convert';

import 'package:coronamaps/models/marker.dart' as mrk;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../keys.dart';

class DataSources {
  static final String all = Keys.dataSourcesAll;
  static final String recovered = Keys.dataSourcesRecovered;

  static Future<List<mrk.Marker>> getAll() async {
    var response = await http.get(all);

    List<mrk.Marker> newList = [];

    var data = json.decode(response.body);
    print("Fetched data");
    data["features"].forEach((val) {
      val = val["attributes"];
      newList.add(mrk.Marker(
          confirmed: val["Confirmed"],
          country: val["Province_State"] != null
              ? val["Province_State"] + ", " + val["Country_Region"]
              : val["Country_Region"],
          deaths: val["Deaths"],
          id: val["OBJECTID"].toString(),
          lastUpdate: val["Last_Update"],
          recovered: val["Recovered"],
          position: LatLng(double.parse(val["Lat"].toString()),
              double.parse(val["Long_"].toString()))));
    });

    return newList;
  }

  static Future<Map> getRecovered() async {
    var response = await http.get(recovered);
    var resp = {};
    var data = json.decode(response.body);
    print("Fetched recovered");
    data["features"].forEach((val) {
      val = val["attributes"];

      resp = {...val};
    });
    print(resp);
    return resp;
    //return 0;
  }
}

/*
newList.add(Marker(
        confirmed: int.parse(val["Confirmed"]),
        country: val["Country_Region"],
        deaths: int.parse(val["Deaths"]),
        id: val["OBJECTID"],
        lastUpdate: int.parse(val["Last_Update"]),
        recovered: int.parse(val["Recovered"]),
        position:
            LatLng(double.parse(val["Lat"]), double.parse(val["Long_"])
            
            )
            
            )

            */
