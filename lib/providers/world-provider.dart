import 'package:coronamaps/helpers/data_sources.dart';
import 'package:flutter/material.dart';

class WorldProvider extends ChangeNotifier {
  int recovered;
  int deaths;
  int confirmed;
  int lastUpdated;

  Future<void> fetchData() async {
    var data = await DataSources.getRecovered();

    recovered = data["recovered"];
    deaths = data["deaths"];
    confirmed = data["confirmed"];

    notifyListeners();
  }
}
