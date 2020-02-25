import 'package:admob_flutter/admob_flutter.dart';
import 'package:coronamaps/providers/news-provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
                            'We couldn\'t fetch the news data from Google\'s servers. Please check your internet connection or contact our customer support.'),
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

    return RefreshIndicator(
      onRefresh: () {
        return _reloadNews();
      },
      child: ListView.builder(
        itemCount: news.length + 2,
        itemBuilder: (context, i) {
          if (i == 0)
            return Container(height: 180,
              child: Card(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: AdmobBanner(
                  adUnitId: "ca-app-pub-1584545233898847/6957889236",
                  adSize: AdmobBannerSize.SMART_BANNER,
                ),
              ),
            );

            if(i % 10 == 0)
            return Text("Loaded from News API with ❤️", style: TextStyle(height: 2) ,textAlign: TextAlign.center, );

          if (i == 1)
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
                          "The newest coronavirus, officially known as COVID-19 (previously 2019-nCoV ARD), has spread to more than 35 nations and sickened 79,700+ people. This concise, 237-page guide to the illness offers a rational, non-alarmist approach from an Amazon #1 best-selling author."),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      onTap: () {
                        launch("https://amzn.to/2HQjqDI");
                      },
                    ),
                  ],
                ));
          i -= 2;



          if(i == 5)
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
                    leading: SizedBox(
                        height: 64,
                        width: 64,
                        child: Image.network(
                          news[i]["urlToImage"],
                        )),
                    title: Text(news[i]["title"]),
                    subtitle: Text(news[i]["description"]),
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
