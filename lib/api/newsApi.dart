import 'dart:developer';

import 'package:flutter/cupertino.dart';

class NewsApi {
  static String apiKey = "593f0bcb482242958a2505eca7fad8e2";
  static String req = "https://newsapi.org/v2/";

  static Uri getTopHeadlines({required String country})  {
    String url = req + "top-headlines?country=$country&apiKey=$apiKey";
    return Uri.parse(url);
  }
}
