import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:newsapp/api/newsApi.dart';
import 'package:newsapp/model/articles.dart';
import 'package:newsapp/model/news_article_result.dart';

class SearchNewsProvider extends ChangeNotifier {
  bool isFetching = false;
  int pageSize = 10;
  int page = 0;
  bool endOfList = false;
  String? query;
  List<Articles> _articles = [];

  List<Articles> get fetchedArticals => _articles;

  changeQuery({required String text}) {
    query = text;
    page = 0;
    endOfList = false;
    _articles.clear();
    fetchSearchResults();
  }

  Future<void> fetchSearchResults() async {
    isFetching = true;
    notifyListeners();
    page++;
    print("query $query");
    final response = await http.get(NewsApi.getSearchResult(
        query: query ?? "", page: page, pageSize: pageSize));
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
      notifyListeners();
    } else {
      page--;
      print("error code" + response.statusCode.toString());
      throw Exception("Failed to get top news");
    }
  }
}
