import 'dart:io';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class CityOverlayWidget {
  late OverlayEntry overlayEntry;
  void insertOverlayCity(
      BuildContext context,
      int recovereds,
      int conf,
      int death,
      String province,
      int lastUpdate,
      int key) {
 

    try {
      overlayEntry.remove();
    } catch (error) {}

    overlayEntry = OverlayEntry(builder: (context) {
      final screen = MediaQuery.of(context).size;
      print(screen.height);
      bool isX = (screen.height >= 896.0) && Platform.isIOS;

      return Padding(
        padding: EdgeInsets.only(
            top: screen.height - 150 - ( (isX ?  25 : 0)),
            left: 20,
            right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Dismissible(
              onDismissed: (direction) {
                overlayEntry.remove();
               
              },
              key: Key(key.toString()),
              child: Card(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      province,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 35, right: 35, top: 0, bottom: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Deaths",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(death.toString())
                              ],
                            ),
                          ),
                          Container(height: 30, child: VerticalDivider()),
                          Column(
                            children: <Widget>[
                              Text(
                                "Confirmed",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(conf.toString())
                            ],
                          ),
                          Container(height: 30, child: VerticalDivider()),
                          Column(
                            children: <Widget>[
                              Text(
                                "Recovered",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(recovereds.toString())
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Text("updated " +
                        timeago.format(
                            DateTime.fromMillisecondsSinceEpoch(lastUpdate))),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });

    return Overlay.of(context).insert(overlayEntry);
  }
}
