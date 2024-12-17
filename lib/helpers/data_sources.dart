import 'dart:convert';

import 'package:coronamaps/models/marker.dart' as mrk;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;



class DataSources {

  static Future<List<mrk.Marker>> getAll() async {
    var response = await http.get(Uri.parse("https://covid-api.com/api/reports"));

    List<mrk.Marker> newList = [];

    var data = json.decode(response.body);
    print("Fetched data");
    data["data"].forEach((val) {
      
      newList.add(mrk.Marker(
          confirmed: int.tryParse(val["confirmed"].toString()) ?? -1,
          country: val["region"]["name"],
          deaths: int.tryParse(val["deaths"].toString()) ?? -1,
          id: val["region"]["iso"],
          lastUpdate: DateTime.parse(val["last_update"]).millisecondsSinceEpoch ,
          recovered: int.tryParse(val["recovered"].toString()) ?? -1,
          position: LatLng(double.tryParse(val["region"]["lat"].toString()) ?? 0   ,
              double.tryParse(val["region"]["long"].toString()) ?? 0  )));
    });

    return newList;
  }

  static Future<Map> getRecovered() async {
    var response = await http.get(Uri.parse("https://covid-api.com/api/reports/total"));
    var data = json.decode(response.body)["data"];
   
    return data;
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
