import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/colors.dart';
import 'package:newsapp/model/articles.dart';
import 'package:shimmer/shimmer.dart';

class BuildNewsCard extends StatelessWidget {
  final Articles article;
  BuildNewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: CustomColors.secondaryWhite,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: IntrinsicHeight(
          // height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 4,
                child: Container(
                  // color: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        article.source.name ?? "Error",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: CustomColors.primaryNavyBlue,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        article.title ?? "Error",
                        maxLines: 3,
                        // textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            color: CustomColors.primaryNavyBlue,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        giveDate(
                          article.publishedAt ?? DateTime.now(),
                        ),
                        style: TextStyle(
                            fontSize: 10,
                            color: CustomColors.primaryNavyBlue,
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 3,
                child: new Hero(
                  tag: article.urlToImage!,
                  transitionOnUserGestures: true,
                  child: Container(
                    height: 100,
                    clipBehavior: Clip.none,
                    decoration: BoxDecoration(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl: article.urlToImage ?? "aa",
                        fit: BoxFit.fill,
                        errorWidget: (context, url, error) {
                          return Container(
                            // width: 200,
                            height: 100,
                            color: Colors.grey.shade400,
                            child: Center(
                              child: Text(
                                "No Image Found",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        progressIndicatorBuilder: (_, __, ___) {
                          return Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              color: Colors.white,
                            ),
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                  ),
                                )),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              )
            ],
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
