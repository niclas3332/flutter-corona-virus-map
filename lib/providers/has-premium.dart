import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class HasPremium extends ChangeNotifier {
  bool _hasPremium = false;
  FirebaseAnalytics analytics = FirebaseAnalytics();

  bool get hasPremium => _hasPremium;

  checkPremium() async {
    var result = await FlutterInappPurchase.instance.initConnection;
    print('result: $result');
    try {
      List<PurchasedItem> purchaseHistory =
          await FlutterInappPurchase.instance.getPurchaseHistory();

      if (purchaseHistory.length > 0) {
        _hasPremium = true;
        analytics.setUserProperty(name: "hasPremium", value: "true");
      } else {
        analytics.setUserProperty(name: "hasPremium", value: "false");
      }

      notifyListeners();
    } catch (err) {
      analytics
          .setUserProperty(name: "hasPremium", value: "false")
          .catchError((err) {});
    }
  }

  setPremium(bool setter) {
    _hasPremium = setter;
    analytics
        .setUserProperty(name: "hasPremium", value: setter.toString())
        .catchError((err) {});

    notifyListeners();
  }
}
