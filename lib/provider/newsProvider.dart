import 'dart:convert';
import 'dart:io';

import 'package:dart_countries/dart_countries.dart';
import 'package:flutter/cupertino.dart';
import 'package:newsapp/api/newsApi.dart';
import 'package:newsapp/model/articles.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/constants/countries.dart';
import 'package:newsapp/model/news_article_result.dart';
import 'package:newsapp/model/source.dart';

class NewsProvider extends ChangeNotifier {
  String selectedCountry = "in";
  bool isFetching = false;
  int pageSize = 15;
  int page = 0;
  bool endOfList = false;
  String? error;
  List<Articles> _articles = [];
  List<Map<String, dynamic>> contryNames = [];
  List<Articles> get fetchedArticals => _articles;
  bool isFetchingSources = false;
  String? errorInFetchingSources;
  List<Source> sources = [];
  List<String> selectedSources = [];
  List<String> sortBy = ["Popular", "Newest", "Oldest"];
  int selectedSortBy = 1;

  void changeSelectedSortBy(int a) {
    selectedSortBy = a;
    fetchInitialtopHeadlines();
  }

  NewsProvider() {
    fetchSources();
    countries.forEach((element) {
      String isoCode = element.isoCode.toString().split('.').last;
      isoCode = isoCode.toLowerCase();
      String name = element.name;
      if (codes.contains(isoCode)) {
        contryNames.add({isoCode: name});
      }
    });
    print("const");
  }

  String get selectedCountryName {
    String _result = "";
    print("object");
    print(contryNames.first.keys.first);
    contryNames.forEach((element) {
      if (element.keys.first == selectedCountry) {
        print(selectedCountry);
        _result = element.values.first;
      }
    });
    return _result;
  }

  void editSource({required List<String> tempsources}) {
    selectedSources = tempsources;
    fetchInitialtopHeadlines();
  }

  void changeCountry({required String name}) {
    if (selectedCountry != name) {
      selectedSources.clear();
      selectedCountry = name;
      endOfList = false;
      fetchInitialtopHeadlines();
      fetchSources();
    }
  }

  Future<void> fetchSources() async {
    print("fetch sources");
    isFetchingSources = true;
    errorInFetchingSources = null;
    sources.clear();
    notifyListeners();
    try {
      http.Response _response =
          await http.get(NewsApi.getSources(country: selectedCountry));
      if (_response.statusCode == 200) {
        final result = jsonDecode(_response.body);
        final List<dynamic> _temp = result["sources"];
        _temp.forEach((element) {
          if (element["id"] != null && element["name"] != null) {
            sources.add(Source.fromJson(element));
          }
        });
        sources.forEach((element) {
          print(element.toJson());
        });
        print("fetch sources" + sources.length.toString());
        isFetchingSources = false;
        notifyListeners();
      } else {
        final _errorResult = jsonDecode(_response.body);
        errorInFetchingSources =
            "Error code : ${_errorResult["code"]}, " + _errorResult["message"];
        isFetchingSources = false;
        notifyListeners();
      }
    } on SocketException {
      print("socket ex");
      print("error" + error.toString());
      errorInFetchingSources = "No Internet Connection";
      isFetchingSources = false;
      notifyListeners();
    }

    notifyListeners();
  }

  fetchInitialtopHeadlines() async {
    if (selectedSortBy == 2) {
      isFetching = true;
      endOfList = false;
      _articles.clear();
      notifyListeners();
      final http.Response response;
      try {
        if (selectedSources.length == 0) {
          response = await http.get(NewsApi.getTopHeadlinesByCountry(
              country: selectedCountry, page: page, pageSize: pageSize));
        } else {
          response = await http.get(NewsApi.getTopHeadlinesBySources(
              sources: selectedSources, page: page, pageSize: pageSize));
        }
        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          final temp = NewsArticleResult.fromJson(result);
          page = ((temp.totalResults!) / pageSize).ceil() + 1;
        } else {
          final _errorResult = jsonDecode(response.body);
          error = "Error code : ${_errorResult["code"]}, " +
              _errorResult["message"];
        }
        endOfList = false;
        _articles.clear();
        fetchtopHeadlines();
      } on SocketException {
        print("socket ex");
        print("error" + error.toString());
        error = "No Internet Connection";
        isFetching = false;
        notifyListeners();
      }
    } else {
      page = 0;
      endOfList = false;
      _articles.clear();
      fetchtopHeadlines();
    }
  }

  Future<void> fetchtopHeadlines() async {
    print("page no" + page.toString());
    if (selectedSortBy == 2) {
      page--;
    } else {
      page++;
    }
    isFetching = true;
    error = null;
    notifyListeners();
    final response;
    try {
      if (selectedSources.length == 0) {
        response = await http.get(NewsApi.getTopHeadlinesByCountry(
            country: selectedCountry, page: page, pageSize: pageSize));
      } else {
        response = await http.get(NewsApi.getTopHeadlinesBySources(
            sources: selectedSources, page: page, pageSize: pageSize));
      }
      _request(response);
    } on SocketException {
      if (selectedSortBy == 2) {
        page++;
      } else {
        page--;
      }
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
      if (selectedSortBy == 2) {
        if (page == 1) {
          endOfList = true;
        }
      } else if (page * pageSize > articleResult.totalResults!) {
        endOfList = true;
      }
      print(articleResult.toJson());
      List<Articles> _tempArticles = [];
      articleResult.articles.forEach((element) {
        if (element.author != null &&
            element.content != null &&
            element.description != null &&
            element.publishedAt != null &&
            element.title != null &&
            element.url != null &&
            element.urlToImage != null) {
          _tempArticles.add(element);
        }
      });
      if (selectedSortBy == 2) {
        _articles.addAll(List.from(_tempArticles.reversed));
      } else {
        _articles.addAll(List.from(_tempArticles));
      }

      if (!endOfList) {
        if (_articles.length <= 7) {
          fetchtopHeadlines();
        }
      }
      print("length" +
          _articles.length.toString() +
          " " +
          articleResult.articles.length.toString());
    } else {
      if (selectedSortBy == 2) {
        page++;
      } else {
        page--;
      }
      final _errorResult = jsonDecode(response.body);
      error =
          "Error code : ${_errorResult["code"]}, " + _errorResult["message"];
    }
    notifyListeners();
  }
}
