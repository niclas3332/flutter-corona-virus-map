import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsProvider extends ChangeNotifier {
  //FirebaseAnalytics analytics = //FirebaseAnalytics();

  List<dynamic> news = [];

  Future<void> loadNews() async {
    //analytics.logEvent(name: "provider_loadNews");

    print("Reload News");
    // var newsJSON = json.decode((await http.get(newsUrl)).body);

    var azure = await http
        .get(Uri.parse("https://www.reddit.com/r/Coronavirus/.json" ));

    news = json.decode(azure.body)["data"]["children"];

    notifyListeners();
  }
}
