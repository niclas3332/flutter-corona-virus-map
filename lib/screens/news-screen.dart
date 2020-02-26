import 'dart:io';
import 'package:coronamaps/keys.dart';
import 'package:coronamaps/providers/has-premium.dart';
import 'package:coronamaps/providers/news-provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool isLoading = true;
  bool isError = false;
  _reloadNews() {
    print("Load News");

    setState(() {
      isError = false;
      isLoading = true;
    });

    Provider.of<NewsProvider>(context, listen: false)
        .loadNews()
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    }).catchError((_) {
      setState(() {
        isError = true;
      });
    });
  }

  @override
  void initState() {
    _reloadNews();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var news = Provider.of<NewsProvider>(context).news;
    bool hasPremium = Provider.of<HasPremium>(context).hasPremium;

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (isError)
      return RefreshIndicator(
        onRefresh: () => _reloadNews(),
        child: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        contentPadding:
                            EdgeInsets.only(left: 10, right: 10, top: 20),
                        leading: Icon(Icons.error),
                        title: Text('An error occurred'),
                        subtitle: Text(
                            'We couldn\'t fetch the news data from Microsoft Azure\'s servers. Please check your internet connection or contact our customer support.'),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('TRY AGAIN'),
                            onPressed: () {
                              _reloadNews();
                            },
                          ),
                          FlatButton(
                            child: const Text('CONTACT US'),
                            onPressed: () {
                              launch(
                                  ("mailto:apps@niclas.xyz?subject=Corona%20Map%20App:%20Fetch%20News%20no%20connection"));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    print(news.length);
    return RefreshIndicator(
      onRefresh: () {
        return _reloadNews();
      },
      child: ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, i) {
          print(i);
          if (i == 0 && !hasPremium)
            return Container(
              height: 180,
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                elevation: 5,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: NativeAdmobBannerView(
                  adUnitID: Platform.isIOS
                      ? Keys.smartAdUnitIdiOS
                      : Keys.smartAdUnitId,
                  style: BannerStyle.light, // enum dark or light
                  showMedia: true, // whether to show media view or not
                  contentPadding: EdgeInsets.all(10), // content padding
                  onCreate: (controller) {
                    controller
                        .setStyle(BannerStyle.light); // Dynamic update style
                  },
                ),
              ),
            );

          if (i % 15 == 0 && !hasPremium)
            return Container(
              height: 180,
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                elevation: 5,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: NativeAdmobBannerView(
                  adUnitID: Platform.isIOS
                      ? Keys.smartAdUnitIdiOS
                      : Keys.smartAdUnitId,
                  style: BannerStyle.light, // enum dark or light
                  showMedia: true, // whether to show media view or not
                  contentPadding: EdgeInsets.all(10), // content padding
                  onCreate: (controller) {
                    controller
                        .setStyle(BannerStyle.light); // Dynamic update style
                  },
                ),
              ),
            );

          if (i == 1 && !hasPremium)
            return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                elevation: 5,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: SizedBox(
                          height: 64,
                          width: 64,
                          child: Image.network(
                            "https://ws-eu.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=DE&ASIN=B0847MVWBP&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=niclas03-21",
                          )),
                      title: Text(
                          "AD: Wuhan Coronavirus: A Concise & Rational Guide to the 2020 Outbreak"),
                      subtitle: Text(
                        "The newest coronavirus, officially known as COVID-19 (previously 2019-nCoV ARD), has spread to more than 35 nations and sickened 79,700+ people. This concise, 237-page guide to the illness offers a rational, non-alarmist approach from an Amazon #1 best-selling author.",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      onTap: () {
                        launch("https://amzn.to/2HQjqDI");
                      },
                    ),
                  ],
                ));

          if (i == 5 && !hasPremium)
            return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                elevation: 5,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: SizedBox(
                          height: 64,
                          width: 64,
                          child: Image.network(
                            "https://ws-eu.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=DE&ASIN=B084C3PBTQ&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=niclas03-21",
                          )),
                      title: Text(
                          "AD: 100 PCS Medical Masks Disposable Face Masks with Elastic Ear Loop"),
                      subtitle: Text(""),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      onTap: () {
                        launch("https://amzn.to/2TanGDn");
                      },
                    ),
                  ],
                ));

          return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              elevation: 5,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: news[i]["image"] != null
                        ? SizedBox(
                            height: 64,
                            width: 64,
                            child: Image.network(
                              news[i]["image"] != null
                                  ? news[i]["image"]["thumbnail"]["contentUrl"]
                                  : "",
                            ))
                        : null,
                    title: Text(news[i]["name"],
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text(
                      timeago.format(DateTime.parse(news[i]["datePublished"])) +
                          " - " +
                          news[i]["description"],
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    onTap: () {
                      launch(news[i]["url"]);
                    },
                  ),
                ],
              ));
        },
      ),
    );
  }
}
