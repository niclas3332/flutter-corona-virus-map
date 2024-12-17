import 'package:coronamaps/helpers/data_sources.dart';
import 'package:flutter/material.dart';

class WorldProvider extends ChangeNotifier {
  int recovered = 0;
   int deaths = 0;
   int confirmed = 0;
   int lastUpdated = 0;

  Future<void> fetchData() async {
    var data = await DataSources.getRecovered();

    recovered = int.tryParse(data["recovered"].toString()) ?? -1;
    deaths = int.tryParse(data["deaths"].toString()) ?? -1;
    confirmed = int.tryParse(data["confirmed"].toString()) ?? -1;



    notifyListeners();
  }
}
