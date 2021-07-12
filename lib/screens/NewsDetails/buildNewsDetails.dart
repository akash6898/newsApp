import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/model/articles.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildNewsDetails extends StatefulWidget {
  final Articles article;
  BuildNewsDetails({required this.article});
  @override
  _BuildNewsDetailsState createState() => _BuildNewsDetailsState();
}

class _BuildNewsDetailsState extends State<BuildNewsDetails> {
  @override
  Widget build(BuildContext context) {
    print(widget.article.content);
    return Scaffold(
      backgroundColor: CustomColors.secondaryWhite,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryBlue,
        leading: IconButton(
          icon: ImageIcon(AssetImage("images/back.png")),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 300.h,
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  child: Hero(
                    tag: widget.article.urlToImage!,
                    transitionOnUserGestures: true,
                    child: CachedNetworkImage(
                      imageUrl:
                          widget.article.urlToImage ?? "www.dat.com/ip.png",
                      fit: BoxFit.fill,
                      colorBlendMode: BlendMode.srcATop,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      errorWidget: (context, url, error) {
                        return Container(
                          color: Colors.grey.shade400,
                          child: Center(
                            child: Text(
                              " No Image Found",
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
                            borderRadius: BorderRadius.all(Radius.circular(16)),
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
                Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Text(
                          widget.article.title ?? "error",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              color: CustomColors.secondaryWhite,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Container(
                color: CustomColors.secondaryWhite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.article.source.name ?? "Error",
                      style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: CustomColors.primaryNavyBlue,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      giveDateTime(
                          widget.article.publishedAt ?? DateTime.now()),
                      style: TextStyle(
                          fontSize: 10,
                          color: CustomColors.primaryNavyBlue,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.article.content ?? "error",
                      style: TextStyle(
                          fontSize: 14,
                          color: CustomColors.primaryNavyBlue,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () => _launchURL(widget.article.url!),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "See Full story",
                            style: TextStyle(
                                fontSize: 14,
                                color: CustomColors.primaryBlue,
                                fontWeight: FontWeight.w700),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: CustomColors.primaryBlue,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String giveDateTime(DateTime _dateTime) {
    return DateFormat('dd MMM, yyyy').format(_dateTime) +
        " at " +
        DateFormat('h:mm a').format(_dateTime);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
