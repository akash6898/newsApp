import 'dart:developer';

import 'package:flutter/cupertino.dart';

class NewsApi {
  // static String apiKey = "593f0bcb482242958a2505eca7fad8e2";
  // static String apiKey = "2653f5a7bc234e24935a4de4edf78351";
  // static String apiKey = "e74d34874c354f82bfc6f97c4701e27b";
  static String apiKey = "fe06cb6e48044a7fb4e1bb07ac88deff";

  static String endPoint = "https://newsapi.org/v2/";

  static Uri getTopHeadlinesByCountry(
      {required String country, required int page, required int pageSize}) {
    String url = endPoint +
        "top-headlines?country=$country&apiKey=$apiKey&pageSize=$pageSize&page=$page";
    return Uri.parse(url);
  }

  static Uri getTopHeadlinesBySources(
      {required List<String> sources,
      required int page,
      required int pageSize}) {
    String _apiSources = "";
    sources.forEach((element) {
      _apiSources = _apiSources + element + ",";
    });
    _apiSources = _apiSources.substring(0, _apiSources.length - 1);
    String url = endPoint +
        "top-headlines?sources=$_apiSources&apiKey=$apiKey&pageSize=$pageSize&page=$page";
    return Uri.parse(url);
  }

  static Uri getSearchResult(
      {required String query, required int page, required int pageSize}) {
    String url = endPoint +
        'everything?q="${Uri.encodeComponent(query)}"&apiKey=$apiKey&pageSize=$pageSize&page=$page&sortBy=publishedAt';
    return Uri.parse(url);
  }

  static Uri getSources({required String country}) {
    String url =
        endPoint + 'top-headlines/sources?country=$country&apiKey=$apiKey';
    return Uri.parse(url);
  }
}
