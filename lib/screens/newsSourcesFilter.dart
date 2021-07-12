import 'package:custom_check_box/custom_check_box.dart';
import 'package:dart_countries/dart_countries.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/colors.dart';
import 'package:newsapp/model/news_article_result.dart';
import 'package:newsapp/model/source.dart';
import 'package:newsapp/provider/newsProvider.dart';
import 'package:newsapp/screens/NoInternet.dart';
import 'package:provider/provider.dart';

class NewsSoucesFilter extends StatefulWidget {
  @override
  _NewsSoucesFilterState createState() => _NewsSoucesFilterState();
}

class _NewsSoucesFilterState extends State<NewsSoucesFilter> {
  List<String> _selected = [];
  @override
  void initState() {
    _selected = context.read<NewsProvider>().selectedSources;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("co");
    NewsProvider _newsProvider = Provider.of(context);
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.secondaryWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: _newsProvider.errorInFetchingSources == "No Internet Connection"
          ? NoInternet(onRetry: () {
              _newsProvider.fetchSources();
            })
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 7,
                    height: 8,
                    decoration: BoxDecoration(
                        color: CustomColors.secondarygrey,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Filter by sources",
                  style: TextStyle(
                      fontSize: 15,
                      color: CustomColors.primaryNavyBlue,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                  color: CustomColors.secondarygrey,
                ),
                Container(
                  height: 200,
                  child: buildListView(_newsProvider),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    child: ElevatedButton(
                      child: Text(
                        "Apply Filter",
                        style: TextStyle(
                            fontSize: 15,
                            color: CustomColors.secondaryWhite,
                            fontWeight: FontWeight.w500),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: CustomColors.primaryBlue),
                      onPressed: _newsProvider.sources.length == 0
                          ? null
                          : () {
                              print("sources listt");
                              print(_selected);
                              context
                                  .read<NewsProvider>()
                                  .editSource(tempsources: _selected);
                              Navigator.of(context).pop();
                            },
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget buildListView(NewsProvider _newsProvider) {
    if (_newsProvider.sources.length != 0) {
      return ListView.builder(
        itemBuilder: (_, index) {
          bool isActive = false;

          if (_selected.contains(_newsProvider.sources[index].id)) {
            isActive = true;
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _newsProvider.sources[index].name!,
                style: TextStyle(
                    fontSize: 14,
                    color: isActive
                        ? CustomColors.primaryBlue
                        : CustomColors.primaryNavyBlue,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500),
              ),
              Checkbox(
                  value: isActive,
                  activeColor: CustomColors.primaryBlue,
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        _selected.add(_newsProvider.sources[index].id);
                      } else {
                        _selected.remove(_newsProvider.sources[index].id);
                      }
                    });
                  })
            ],
          );
        },
        itemCount: _newsProvider.sources.length,
      );
    } else if (_newsProvider.isFetching && _newsProvider.sources.length == 0) {
      return Center(child: CircularProgressIndicator());
    } else if (_newsProvider.errorInFetchingSources != null &&
        _newsProvider.sources.length == 0) {
      return Center(
        child: Text(_newsProvider.errorInFetchingSources!),
      );
    } else if (_newsProvider.sources.length == 0) {
      return Center(
        child: Text("No Sources Found"),
      );
    }
    return SizedBox();
  }
}
