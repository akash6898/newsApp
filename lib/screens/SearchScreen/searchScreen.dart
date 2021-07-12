import 'package:flutter/material.dart';
import 'package:newsapp/provider/newsProvider.dart';
import 'package:newsapp/provider/searchNewsProvider.dart';
import 'package:newsapp/screens/Common/NoInternet.dart';
import 'package:newsapp/screens/Common/buildNewsCard.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';

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
        print("lenght pop" +
            _searchNewsProvider.fetchedArticals.length.toString());

        // _searchNewsProvider.clear();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.secondaryWhite,
        appBar: AppBar(
          backgroundColor: CustomColors.primaryBlue,
          leading: IconButton(
            icon: ImageIcon(AssetImage("images/back.png")),
            onPressed: () {
              print("lenght pop" +
                  _searchNewsProvider.fetchedArticals.length.toString());

              _searchNewsProvider.clear();
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
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _searchNewsProvider.error ?? "error",
              style: TextStyle(color: CustomColors.primaryNavyBlue),
            ),
            ElevatedButton(
              onPressed: () {
                _searchNewsProvider.fetchSearchResults();
              },
              child: Text(
                "Try Again",
                style: TextStyle(
                    fontSize: 15,
                    color: CustomColors.secondaryWhite,
                    fontWeight: FontWeight.w500),
              ),
              style:
                  ElevatedButton.styleFrom(primary: CustomColors.primaryBlue),
            )
          ],
        )),
      );
    }

    if (_searchNewsProvider.fetchedArticals.isEmpty) {
      return Expanded(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageIcon(
              AssetImage("images/newspaper.png",),
              size: 40,
              color: CustomColors.primaryNavyBlue
            ),
            SizedBox(
              height: 10,
            ),
            Text("No Results",style: TextStyle(color: CustomColors.primaryNavyBlue)),
          ],
        ),
      ));
    }
    print("lenght" + _searchNewsProvider.fetchedArticals.length.toString());
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
                  child: Text("End Of List",
                      style: TextStyle(color: CustomColors.primaryNavyBlue)),
                ));
              } else if (_searchNewsProvider.error != null) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _searchNewsProvider.error ?? "error",
                        style: TextStyle(color: CustomColors.primaryNavyBlue),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _searchNewsProvider.fetchSearchResults();
                        },
                        child: Text(
                          "Try Again",
                          style: TextStyle(
                              fontSize: 15,
                              color: CustomColors.secondaryWhite,
                              fontWeight: FontWeight.w500),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: CustomColors.primaryBlue),
                      )
                    ],
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

  @override
  void dispose() {
    _scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
