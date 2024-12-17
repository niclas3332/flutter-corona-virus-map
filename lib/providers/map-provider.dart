import 'dart:math';

import 'package:coronamaps/helpers/data_sources.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:coronamaps/models/marker.dart' as mrk;

class MapProvider extends ChangeNotifier {
  Map<CircleId, Circle> _circles = <CircleId, Circle>{};

  Map<CircleId, mrk.Marker> _circleData = <CircleId, mrk.Marker>{};

  Map<CircleId, Circle> get circles => _circles;

  Map<CircleId, mrk.Marker> get circleData => _circleData;

  addCircle(Circle newCircle) {
    _circles[newCircle.circleId] = newCircle;

    notifyListeners();
  }

  addCircles(List<Circle> circles) {
    circles.forEach((f) {
      _circles[f.circleId] = f;
    });
    notifyListeners();
  }

  removeAll() {
    _circles = <CircleId, Circle>{};
    notifyListeners();
  }

  Future<void> fetchOnline() async {
    List<mrk.Marker> _markers = await DataSources.getAll();
    List<Circle> newCircles = [];
    _markers.forEach((element) {
      CircleId circleId = CircleId(element.id);

      newCircles.add(Circle(
          strokeColor: Colors.red,
          fillColor: Colors.red.withOpacity(0.5),
          strokeWidth: 1,
          circleId: circleId,
          center: element.position,
          radius: max(min(element.confirmed.toDouble() * 100, 200000), 5000)));

      _circleData[circleId] = element;
    });
    addCircles(newCircles);
  }

  // Maybe save data in database for caching, etc
  // Function to fetch circles from online Database -> Done
  // Function to fetch circles from offline  Database

}
