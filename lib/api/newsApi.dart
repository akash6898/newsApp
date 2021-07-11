import 'dart:developer';

import 'package:flutter/cupertino.dart';

class NewsApi {
  static String apiKey = "593f0bcb482242958a2505eca7fad8e2";
  // static String apiKey = "2653f5a7bc234e24935a4de4edf78351";

  static String endPoint = "https://newsapi.org/v2/";

  static Uri getTopHeadlines(
      {required String country, required int page, required int pageSize}) {
    String url = endPoint +
        "top-headlines?country=$country&apiKey=$apiKey&pageSize=$pageSize&page=$page";
    return Uri.parse(url);
  }

  static Uri getSearchResult(
      {required String query, required int page, required int pageSize}) {
    String url = endPoint +
        'everything?q="${Uri.encodeComponent(query)}"&apiKey=$apiKey&pageSize=$pageSize&page=$page&sortBy=publishedAt&language=en';
    return Uri.parse(url);
  }
}
