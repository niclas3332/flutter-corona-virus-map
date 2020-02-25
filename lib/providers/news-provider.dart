import 'dart:convert';

import 'package:coronamaps/keys.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsProvider extends ChangeNotifier {
  final String newsUrl = Keys.newsUri;

  List<dynamic> news = [];

  Future<void> loadNews() async {
    print("Reload News");
    var newsJSON = json.decode((await http.get(newsUrl)).body);

    print(newsJSON);

    news = newsJSON["articles"];

    notifyListeners();
  }
}
