import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/model/articles.dart';
import 'package:shimmer/shimmer.dart';

class BuildNewsCard extends StatelessWidget {
  final Articles article;
  BuildNewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Container(
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        article.source.name ?? "Error",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        article.title ?? "Error",
                        maxLines: 3,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(giveDate(article.publishedAt ?? DateTime.now()))
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  flex: 3,
                  child: CachedNetworkImage(
                    imageUrl: article.urlToImage ?? "aa",
                    fit: BoxFit.fitHeight,
                    placeholder: (_, __) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: 200,
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String giveDate(DateTime _dateTime) {
    DateTime _currDateTime = DateTime.now();
    int differeceInSeconds = Duration(
            milliseconds: (_currDateTime.millisecondsSinceEpoch -
                _dateTime.millisecondsSinceEpoch))
        .inSeconds;
    if (differeceInSeconds < 60) {
      return "${differeceInSeconds.toInt()} sec ago";
    } else if (differeceInSeconds < 60 * 60) {
      return "${differeceInSeconds ~/ 60} min  ago";
    } else if (differeceInSeconds < 60 * 60 * 24) {
      return "${differeceInSeconds ~/ (60 * 60)} hour ago";
    } else {
      return "${differeceInSeconds ~/ (60 * 60 * 24)} day ago";
    }
  }
}
