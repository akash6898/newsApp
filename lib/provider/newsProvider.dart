import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:newsapp/api/newsApi.dart';
import 'package:newsapp/model/articles.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/model/news_article_result.dart';

class NewsProvider extends ChangeNotifier {
  String country = "in";
  bool isFetching = false;
  int pageSize = 10;
  int page = 0;
  bool endOfList = false;
  String? error;
  List<Articles> _articles = [];

  List<Articles> get fetchedArticals => _articles;

  Future<void> fetchtopHeadlines() async {
    page++;
    isFetching = true;
    notifyListeners();
    final response = await http.get(NewsApi.getTopHeadlines(
        country: country, page: page, pageSize: pageSize));
    return _request(response);
  }

  void _request(http.Response response) {
    isFetching = false;

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final articleResult = NewsArticleResult.fromJson(result);
      if (page * pageSize > articleResult.totalResults!) {
        endOfList = true;
      }
      print(articleResult.toJson());
      articleResult.articles.forEach((element) {
        if (element.author != null &&
            element.content != null &&
            element.description != null &&
            element.publishedAt != null &&
            element.title != null &&
            element.url != null &&
            element.urlToImage != null) {
          _articles.add(element);
        }
      });
      
    } else {
      page--;
      final _errorResult = jsonDecode(response.body);
      error =
          "Error code : ${_errorResult["code"]}, " + _errorResult["message"];
     
    }
    notifyListeners();
  }
}
