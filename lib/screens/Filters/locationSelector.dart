import 'package:dart_countries/dart_countries.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/constants/countries.dart';
import 'package:newsapp/provider/newsProvider.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';

class LocationSelector extends StatefulWidget {
  @override
  _LocationSelectorState createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  late NewsProvider _newsProvider;
  late String selectdCountry;
  List<Map<String, dynamic>> contryNames = [];

  @override
  void initState() {
    contryNames = context.read<NewsProvider>().contryNames;
    selectdCountry = context.read<NewsProvider>().selectedCountry;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(Country(IsoCode.IN).name);

    return Container(
      decoration: BoxDecoration(
        color: CustomColors.secondaryWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Column(
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
            "Choose Your Location",
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
            height: 180,
            child: ListView.builder(
              itemBuilder: (_, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      contryNames[index].values.first,
                      style: TextStyle(
                          fontSize: 14,
                          color: selectdCountry == contryNames[index].keys.first
                              ? CustomColors.primaryBlue
                              : CustomColors.primaryNavyBlue,
                          fontWeight: FontWeight.w500),
                    ),
                    Radio(
                        value: contryNames[index].keys.first,
                        groupValue: selectdCountry,
                        onChanged: (val) {
                          setState(() {
                            selectdCountry = val.toString();
                          });
                        })
                  ],
                );
              },
              itemCount: contryNames.length,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(primary: CustomColors.primaryBlue),
                child: Text(
                  "Apply",
                  style: TextStyle(
                      fontSize: 15,
                      color: CustomColors.secondaryWhite,
                      fontWeight: FontWeight.w500),
                ),
                onPressed: () {
                  context
                      .read<NewsProvider>()
                      .changeCountry(name: selectdCountry);
                  Navigator.of(context).pop();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
