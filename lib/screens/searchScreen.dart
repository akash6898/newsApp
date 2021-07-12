import 'package:flutter/material.dart';
import 'package:newsapp/provider/newsProvider.dart';
import 'package:newsapp/provider/searchNewsProvider.dart';
import 'package:newsapp/screens/NoInternet.dart';
import 'package:newsapp/screens/buildNewsCard.dart';
import 'package:provider/provider.dart';

import '../colors.dart';

class SeacrhScreen extends StatefulWidget {
  @override
  _SeacrhScreenState createState() => _SeacrhScreenState();
}

class _SeacrhScreenState extends State<SeacrhScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    SearchNewsProvider _searchNewsProvider =
        Provider.of<SearchNewsProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        _searchNewsProvider.clear();
        return true;
      },
      child: Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Hero(
                tag: "Search",
                child: Material(
                  child: TextField(
                      onChanged: (val) {
                        _searchNewsProvider.changeQuery(
                            text: val,
                            countryTemp:
                                context.read<NewsProvider>().selectedCountry,
                            sourceList:
                                context.read<NewsProvider>().selectedSources);
                      },
                      autofocus: true,
                      cursorColor: CustomColors.primaryNavyBlue,
                      style: TextStyle(color: CustomColors.primaryNavyBlue),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          filled: true,
                          hintText: "Search for news,topics..",
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: CustomColors.primaryNavyBlue),
                          fillColor: CustomColors.secondarygrey,
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: CustomColors.secondaryWhite,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: CustomColors.secondaryWhite,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: CustomColors.secondaryWhite,
                              )),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: CustomColors.secondaryWhite,
                              )),
                          suffixIcon: Icon(Icons.search,
                              color: CustomColors.primaryNavyBlue))),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              buildBody(_searchNewsProvider)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody(SearchNewsProvider _searchNewsProvider) {
    if (_searchNewsProvider.isFetching &&
        _searchNewsProvider.fetchedArticals.isEmpty) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (!_searchNewsProvider.isFetching &&
        (_searchNewsProvider.error != null) &&
        _searchNewsProvider.fetchedArticals.isEmpty) {
      if (_searchNewsProvider.error == "No Internet Connection") {
        return Expanded(
          child: Center(
            child: NoInternet(onRetry: () {
              _searchNewsProvider.initialFetchSearch();
            }),
          ),
        );
      }
      return Expanded(
        child: Center(
            child: Center(
                child: Text(
          _searchNewsProvider.error ?? "error",
          style: TextStyle(color: CustomColors.primaryNavyBlue),
        ))),
      );
    }

    if (_searchNewsProvider.fetchedArticals.isEmpty) {
      return Expanded(
          child: Center(
        child: Text("No Results"),
      ));
    }

    return Expanded(
      child: ListView.separated(
          controller: _scrollController
            ..addListener(() {
              if (_scrollController.offset ==
                      _scrollController.position.maxScrollExtent &&
                  !_searchNewsProvider.isFetching &&
                  !_searchNewsProvider.endOfList) {
                print("end");
                _searchNewsProvider.fetchSearchResults();
              }
            }),
          itemBuilder: (context, index) {
            if (index == _searchNewsProvider.fetchedArticals.length) {
              if (_searchNewsProvider.isFetching) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CircularProgressIndicator(),
                ));
              } else if (_searchNewsProvider.endOfList) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text("End Of List"),
                ));
              } else if (_searchNewsProvider.error != null) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    _searchNewsProvider.error ?? "error",
                    style: TextStyle(color: CustomColors.primaryNavyBlue),
                  ),
                ));
              } else
                return SizedBox();
            }

            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed("/buildNewsDetails",
                    arguments: {
                      'article': _searchNewsProvider.fetchedArticals[index]
                    });
              },
              child: BuildNewsCard(
                  article: _searchNewsProvider.fetchedArticals[index]),
            );
          },
          separatorBuilder: (_, __) {
            return SizedBox(
              height: 20,
            );
          },
          itemCount: _searchNewsProvider.fetchedArticals.length + 1),
    );
  }
}
