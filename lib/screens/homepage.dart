import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/colors.dart';
import 'package:newsapp/model/articles.dart';
import 'package:newsapp/provider/newsProvider.dart';
import 'package:newsapp/screens/locationSelector.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

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
    context.read<NewsProvider>().fetchInitialtopHeadlines();
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
              Text("MyNEWS"),
              GestureDetector(
                onTap: () {
                  _modalBottomSheetMenu(child: LocationSelector());
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Location"),
                    Row(
                      children: [
                        Icon(Icons.place),
                        Text(_newsProvider.selectedCountryName),
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
            // backgroundColor: Colors.amber,
            onPressed: () {
              _modalBottomSheetMenu(child: NewsSoucesFilter());
            },
            child: Icon(Icons.filter_list),
          ),
        ),
        body: Padding(
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
                if (_scrollController.position.outOfRange &&
                    !_newsProvider.isFetching &&
                    !_newsProvider.endOfList) {
                  _newsProvider.fetchtopHeadlines();
                }
              }),
            itemBuilder: (context, index) {
              if (index == 0) {
                return buildHeader();
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
                    child: Text("End Of List"),
                  ));
                } else if (_newsProvider.error != null) {
                  return Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child:
                          Center(child: Text(_newsProvider.error ?? "error")));
                } else {
                  _newsProvider.fetchtopHeadlines();
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }
              }
              print(index);
              print(_newsProvider.fetchedArticals[index - 1].toJson());
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/buildNewsDetails',
                      arguments: {
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

  Widget buildHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/search');
          },
          child: Hero(
            tag: "Search",
            child: Material(
              child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      filled: true,
                      hintText: "Search for news,topics..",
                      hintStyle: TextStyle(fontSize: 14),
                      fillColor: CustomColors.secondarygrey,
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(
                            color: CustomColors.secondaryWhite,
                          )),
                      suffixIcon: Icon(Icons.search))),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Top Headlines"),
            Row(
              children: [
                Text("Sort: "),
                PortalEntry(
                  visible: isMenuOpen,
                  portal: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        isMenuOpen = !isMenuOpen;
                      });
                    },
                  ),
                  child: PortalEntry(
                    visible: isMenuOpen,
                    portalAnchor: Alignment.topCenter,
                    childAnchor: Alignment.bottomCenter,
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isMenuOpen = !isMenuOpen;
                          });
                        },
                        child: Row(
                          children: [
                            Text(_newsProvider
                                .sortBy[_newsProvider.selectedSortBy]),
                            Icon(Icons.arrow_circle_down_outlined),
                          ],
                        )),
                    portal: Material(
                      elevation: 8,
                      child: IntrinsicWidth(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                isMenuOpen = !isMenuOpen;
                                _newsProvider.changeSelectedSortBy(0);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                child: Text(_newsProvider.sortBy[0]),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                isMenuOpen = !isMenuOpen;
                                _newsProvider.changeSelectedSortBy(1);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                child: Text(_newsProvider.sortBy[1]),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                isMenuOpen = !isMenuOpen;
                                _newsProvider.changeSelectedSortBy(2);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                child: Text(_newsProvider.sortBy[2]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
