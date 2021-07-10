import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:newsapp/api/newsApi.dart';
import 'package:newsapp/model/articles.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/model/news_article_result.dart';

class NewsProvider extends ChangeNotifier {
  String country = "in";
  bool isFetching = false;
  List<Articles> _articles =[];

  List<Articles> get fetchedArticals => _articles;


  Future<void> fetchtopHeadlines() async {
    isFetching = true;
    final response = await http.get(NewsApi.getTopHeadlines(country: country));
    return _request(response);
  }

  void _request(http.Response response) {
    isFetching = false;
    
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final articleResult = NewsArticleResult.fromJson(result);
      print(articleResult.toJson());
      _articles =  articleResult.articles;
      notifyListeners();
    } else {
      throw Exception("Failed to get top news");
    }
  }
}
