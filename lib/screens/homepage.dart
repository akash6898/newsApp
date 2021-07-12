import 'package:flutter/material.dart';
import 'package:newsapp/colors.dart';
import 'package:newsapp/provider/newsProvider.dart';
import 'package:newsapp/screens/NoInternet.dart';
import 'package:newsapp/screens/buildHeader.dart';
import 'package:newsapp/screens/locationSelector.dart';
import 'package:provider/provider.dart';
import 'buildNewsCard.dart';
import 'newsSourcesFilter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isMenuOpen = false;
  late NewsProvider _newsProvider;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback(
        (_) => context.read<NewsProvider>().fetchInitialtopHeadlines());

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _newsProvider = Provider.of(context);

    return Scaffold(
        backgroundColor: CustomColors.secondaryWhite,
        appBar: AppBar(
          backgroundColor: CustomColors.primaryBlue,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "MyNEWS",
                style: TextStyle(
                    color: CustomColors.secondaryWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              GestureDetector(
                onTap: () {
                  _modalBottomSheetMenu(child: LocationSelector());
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Location",
                      style: TextStyle(
                          color: CustomColors.secondaryWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.place,
                          size: 12,
                        ),
                        Text(
                          _newsProvider.selectedCountryName,
                          style: TextStyle(
                              color: CustomColors.secondaryWhite,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FloatingActionButton(
            backgroundColor: CustomColors.primaryBlue,
            // backgroundColor: Colors.amber,
            onPressed: () {
              _modalBottomSheetMenu(child: NewsSoucesFilter());
            },
            child: ImageIcon(AssetImage("images/filter.png")),
          ),
        ),
        body: _newsProvider.error == "No Internet Connection"
            ? NoInternet(
                onRetry: () {
                  _newsProvider.fetchInitialtopHeadlines();
                },
              )
            : Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: ListView.separated(
                  separatorBuilder: (_, __) {
                    return SizedBox(
                      height: 20,
                    );
                  },
                  controller: _scrollController
                    ..addListener(() {
                      print("end " +
                          _newsProvider.isFetching.toString() +
                          _newsProvider.endOfList.toString());
                      if (_scrollController.offset ==
                              _scrollController.position.maxScrollExtent &&
                          !_newsProvider.isFetching &&
                          !_newsProvider.endOfList) {
                        _newsProvider.fetchtopHeadlines();
                      }
                    }),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return BuildHeader();
                    }

                    if (index == _newsProvider.fetchedArticals.length + 1) {
                      if (_newsProvider.isFetching) {
                        if (_newsProvider.fetchedArticals.isEmpty) {
                          return Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (_newsProvider.endOfList) {
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            "End Of List",
                            style:
                                TextStyle(color: CustomColors.primaryNavyBlue),
                          ),
                        ));
                      } else if (_newsProvider.error != null) {
                        return Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: Center(
                                child: Text(
                              _newsProvider.error ?? "error",
                              style: TextStyle(
                                  color: CustomColors.primaryNavyBlue),
                            )));
                      } else {
                        // _newsProvider.fetchtopHeadlines();
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Center(
                                child: Text(
                              "End Of List",
                              style: TextStyle(
                                  color: CustomColors.primaryNavyBlue),
                            )),
                          ),
                        );
                      }
                    }
                    print(index);
                    print(_newsProvider.fetchedArticals[index - 1].toJson());
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/buildNewsDetails', arguments: {
                          'article': _newsProvider.fetchedArticals[index - 1]
                        });
                      },
                      child: BuildNewsCard(
                        article: _newsProvider.fetchedArticals[index - 1],
                      ),
                    );
                  },
                  itemCount: _newsProvider.fetchedArticals.length + 2,
                ),
              ));
  }

  void _modalBottomSheetMenu({required child}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        // barrierColor: Color.fromRGBO(0, 0, 0, 0.15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (builder) {
          return child;
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
