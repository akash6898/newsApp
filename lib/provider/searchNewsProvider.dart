import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:newsapp/api/newsApi.dart';
import 'package:newsapp/model/articles.dart';
import 'package:newsapp/model/news_article_result.dart';
import 'package:newsapp/model/source.dart';

class SearchNewsProvider extends ChangeNotifier {
  bool isFetching = false;
  int pageSize = 10;
  int page = 0;
  bool endOfList = false;
  String? query;
  String? error;
  List<Articles> _articles = [];
  List<String>? _sources = [];
  String? country;
  List<Articles> get fetchedArticals => _articles;

  changeQuery(
      {required String text,
      required List<String> sourceList,
      required String countryTemp}) {
    print("in change query " + text.length.toString());
    query = text;
    _sources = sourceList;
    country = countryTemp;
    initialFetchSearch();
  }

  void clear() {
    page = 0;
    endOfList = false;
    error = null;
    _articles.clear();
    notifyListeners();
  }

  void initialFetchSearch() {
    page = 0;
    error = null;
    endOfList = false;

    _articles.clear();
    if (query!.length == 0) {
      notifyListeners();
    } else
      fetchSearchResults();
  }

  Future<void> fetchSearchResults() async {
    isFetching = true;
    error = null;
    notifyListeners();
    page++;
    print("query $query");
    try {
      if (_sources!.length == 0) {
        final response = await http.get(NewsApi.getSearchResultByCountry(
            query: query ?? "",
            page: page,
            pageSize: pageSize,
            country: country!));
        return _request(response);
      } else {
        final response = await http.get(NewsApi.getSearchResultBySources(
            query: query ?? "",
            page: page,
            pageSize: pageSize,
            sources: _sources!));
        return _request(response);
      }
    } on SocketException {
      page--;
      print("socket ex");
      print("error" + error.toString());
      error = "No Internet Connection";
      isFetching = false;

      notifyListeners();
    }
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
      final _errorResult = jsonDecode(response.body);
      error =
          "Error code : ${_errorResult["code"]}, " + _errorResult["message"];
      notifyListeners();
      // throw Exception("Failed to get top news");
    }
  }
}
