import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class HasPremium extends ChangeNotifier {
  bool _hasPremium = false;

  bool get hasPremium => _hasPremium;

  checkPremium() async {
    var result = await FlutterInappPurchase.instance.initConnection;
    print('result: $result');

    List<PurchasedItem> purchaseHistory =
        await FlutterInappPurchase.instance.getPurchaseHistory();

    if (purchaseHistory.length > 0) _hasPremium = true;

    notifyListeners();
  }

  setPremium(bool setter) {
    _hasPremium = setter;
    notifyListeners();
  }
}