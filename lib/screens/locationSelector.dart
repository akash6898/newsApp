import 'package:dart_countries/dart_countries.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/model/countries.dart';
import 'package:newsapp/provider/newsProvider.dart';
import 'package:provider/provider.dart';

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
        color: Color.fromRGBO(249, 250, 254, 1),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text("Choose Your Location"),
          SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 2,
          ),
          Container(
            height: 200,
            child: ListView.builder(
              itemBuilder: (_, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(contryNames[index].values.first),
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
                child: Text("Apply"),
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
