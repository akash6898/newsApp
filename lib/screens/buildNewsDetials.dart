import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/model/articles.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
      appBar: AppBar(
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
                  height: 300,
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
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.article.source.name ?? "Error"),
                  Text(giveDateTime(
                      widget.article.publishedAt ?? DateTime.now())),
                  SizedBox(
                    height: 20,
                  ),
                  Text(widget.article.content ?? "error"),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () => _launchURL(widget.article.url!),
                    child: Text("See Full story"),
                  )
                ],
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
