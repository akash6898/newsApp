import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/provider/newsProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildHeader extends StatefulWidget {
  @override
  _BuildHeaderState createState() => _BuildHeaderState();
}

class _BuildHeaderState extends State<BuildHeader> {
  bool isMenuOpen = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 10.h,
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
                      hintStyle: TextStyle(
                          fontSize: 14, color: CustomColors.primaryNavyBlue),
                      fillColor: CustomColors.secondarygrey,
                      disabledBorder: OutlineInputBorder(
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
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Top Headlines",
              style: TextStyle(
                  fontSize: 16,
                  color: CustomColors.primaryNavyBlue,
                  fontWeight: FontWeight.w700),
            ),
            Row(
              children: [
                Text(
                  "Sort: ",
                  style: TextStyle(
                      fontSize: 12,
                      color: CustomColors.primaryNavyBlue,
                      fontWeight: FontWeight.w500),
                ),
                Consumer<NewsProvider>(builder: (context, _newsProvider, _) {
                  return PortalEntry(
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  _newsProvider
                                      .sortBy[_newsProvider.selectedSortBy],
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: CustomColors.primaryNavyBlue,
                                      fontWeight: FontWeight.w500)),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 14,
                              ),
                            ],
                          )),
                      portal: Material(
                        elevation: 8,
                        color: CustomColors.secondaryWhite,
                        child: IntrinsicWidth(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              InkWell(
                                onTap: () {
                                  isMenuOpen = !isMenuOpen;
                                  _newsProvider.changeSelectedSortBy(0);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 13, right: 25),
                                  child: Text(_newsProvider.sortBy[0]),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  isMenuOpen = !isMenuOpen;
                                  _newsProvider.changeSelectedSortBy(1);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 13, right: 25),
                                  child: Text(_newsProvider.sortBy[1]),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  isMenuOpen = !isMenuOpen;
                                  _newsProvider.changeSelectedSortBy(2);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 13, right: 25),
                                  child: Text(_newsProvider.sortBy[2]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            )
          ],
        ),
      ],
    );
  }
}
