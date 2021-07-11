import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/model/articles.dart';
import 'package:newsapp/provider/newsProvider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'buildNewsCard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<NewsProvider>().fetchtopHeadlines();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NewsProvider _newsProvider = Provider.of(context);
    final ScrollController _scrollController = ScrollController();
    return Scaffold(
        appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("MyNEWS"),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Location"),
                  Text("Idea"),
                ],
              )
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: ListView.separated(
            separatorBuilder: (_, __) {
              return SizedBox(
                height: 20,
              );
            },
            controller: _scrollController
              ..addListener(() {
                if (_scrollController.offset ==
                        _scrollController.position.maxScrollExtent &&
                    !_newsProvider.isFetching &&
                    !_newsProvider.endOfList) {
                  print("end");
                  _newsProvider.fetchtopHeadlines();
                }
              }),
            itemBuilder: (context, index) {
              if (index == 0) {
                return buildHeader();
              }

              if (index == _newsProvider.fetchedArticals.length + 1) {
                if (_newsProvider.isFetching) {
                  if(_newsProvider.fetchedArticals.isEmpty)
                  {
                    return Container(height: MediaQuery.of(context).size.height/2,child: Center(child: CircularProgressIndicator(),),);
                  }
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CircularProgressIndicator(),
                  ));
                } else if (_newsProvider.endOfList) {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text("End Of List"),
                  ));
                } else
                  return Container(height: MediaQuery.of(context).size.height/2 , child: Center(child: Text(_newsProvider.error??"error")));
              }
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/buildNewsDetails',
                      arguments: {
                        'article': _newsProvider.fetchedArticals[index-1]
                      });
                },
                child: BuildNewsCard(
                  article: _newsProvider.fetchedArticals[index-1],
                ),
              );
            },
            itemCount: _newsProvider.fetchedArticals.length + 2,
          ),
        ));
  }

  Widget buildHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/search');
          },
          child: Hero(
            tag: "Search",
            child: Material(
                          child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                      filled: true,
                      hintText: "Search for news,topics..",
                      hintStyle: TextStyle(fontSize: 14),
                      fillColor: Colors.grey.shade300,
                      suffixIcon: Icon(Icons.search))),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Top Headlines"),
            Text("Sort"),
          ],
        ),
      ],
    );
  }
}
