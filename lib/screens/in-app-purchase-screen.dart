import 'dart:async';
import 'dart:io';
import 'package:coronamaps/providers/has-premium.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:provider/provider.dart';

class RemoveAdsScreen extends StatefulWidget {
  @override
  _RemoveAdsScreenState createState() => _RemoveAdsScreenState();
}

class _RemoveAdsScreenState extends State<RemoveAdsScreen> {
  static const String iapId = 'android.test.purchased';
  List<IAPItem> _items = [];
  List<PurchasedItem> purchaseHistory = [];
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // prepare
    print("Start init");
    var result = await FlutterInappPurchase.instance.initConnection;
    print('result: $result');

    purchaseHistory = await FlutterInappPurchase.instance.getPurchaseHistory();

    print(purchaseHistory.length);
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    print("Is Mounted?");
    if (!mounted) return;
    print("Mounted");
    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAllItems;
      print('consumeAllItems: $msg');
    } catch (err) {
      print(err);
    }

    print("Start getting prods");
    await _getProduct();
    print("Gettet Prods");
  }

  Future<Null> _getProduct() async {
    List<IAPItem> items2 = await FlutterInappPurchase.instance
        .getProducts(["remove_ads", "remove_ads_5", "remove_ads_1"]);

    List<IAPItem> items = await FlutterInappPurchase.instance
        .getSubscriptions(["remove_ads_abo", "remove_ads_abo_2"]);

    if (purchaseHistory.where((test) {
          if (test.productId == "remove_ads_abo" ||test.productId == "remove_ads_abo_2"  ) return true;
          return false;
        }).length ==
        0)
      for (var item in items) {
        print('${item.toString()}');
        this._items.add(item);
      }

    for (var item in items2) {
      print('${item.toString()}');
      this._items.add(item);
    }

    setState(() {});
  }


Future<void> _neverSatisfied() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Thank you for your purchase!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Now all ads are gone.'),
              Text('Thank\'s for your support.'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


  Future<Null> _buyProduct(IAPItem item) async {
    try {
      PurchasedItem purchased =
          await FlutterInappPurchase.instance.requestPurchase(item.productId);
      print(purchased);
      String msg = await FlutterInappPurchase.instance.consumeAllItems;

      
      Provider.of<HasPremium>(context, listen: false).checkPremium();
      print('consumeAllItems: $msg');
      _neverSatisfied();
    } catch (error) {
      print('$error');
    }
  }

  List<Widget> _renderButton() {
    List<Widget> widgets = this
        ._items
        .map(
          (item) => Container(
            width: double.infinity,
            child: Card(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 12.0),
                  (double.parse(item.price) < 1)
                      ? Text("A small gesture")
                      : (double.parse(item.price) > 5)
                          ? Text("Something to eat")
                          : Text("A cup of coffee"),
                  SizedBox(height: 12.0),
                  SizedBox(
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: () => _buyProduct(item),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      child: Text(
                        'Spend ${item.price} ${item.currency} ${Platform.isIOS ? ( item.subscriptionPeriodNumberIOS != null ?  item.subscriptionPeriodNumberIOS + " " + item.subscriptionPeriodUnitIOS : "" ) : item.subscriptionPeriodAndroid != null ? item.subscriptionPeriodAndroid : ""}',
                        style: Theme.of(context).primaryTextTheme.button,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        )
        .toList();
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 24,
            ),
            Text("Hey, it would be nice, if you reward my work.",
                style: TextStyle(fontSize: 16)),
            SizedBox(
              height: 24,
            ),
            ..._renderButton(),
            SizedBox(
              height: 24,
            ),
            Text(
              "Buy something of these to remove ads.\nIt doesn't care about how much you pay.\nIt's all about support.\nThank you for your support.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ],
    );
  }
}
