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
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Top Headlines"),
                  Text("Sort"),
                ],
              ),
              _newsProvider.isFetching
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: Container(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return BuildNewsCard(
                              article: _newsProvider.fetchedArticals[index],
                            );
                          },
                          itemCount: _newsProvider.fetchedArticals.length,
                        ),
                      ),
                    )
            ],
          ),
        ));
  }
}
