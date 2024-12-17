import 'package:coronamaps/providers/news-provider.dart';
import 'package:timeago/timeago.dart' as timeago;

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
  Future<void> _reloadNews () async {
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

    if (isError) {
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
                          TextButton(
                            child: const Text('TRY AGAIN'),
                            onPressed: () {
                              _reloadNews();
                            },
                          ),
                          TextButton(
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
    }

    return RefreshIndicator(
      onRefresh: () {
        return _reloadNews();
      },
      child: ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, i) {
          print(i);

          return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              elevation: 5,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: null,
                    title: Text(news[i]["data"]["title"],
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text(
                      "${timeago.format(DateTime.fromMillisecondsSinceEpoch(
                              news[i]["data"]["created_utc"] * 10000))} - ${news[i]["data"]["selftext"]}",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    onTap: () {
                      launchUrl(Uri.parse(news[i]["data"]["url"]));
                    },
                  ),
                ],
              ));
        },
      ),
    );
  }
}
