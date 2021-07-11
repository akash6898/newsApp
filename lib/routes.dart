import 'package:flutter/material.dart';
import 'package:newsapp/screens/buildNewsDetials.dart';
import 'package:newsapp/screens/homepage.dart';
import 'package:newsapp/screens/searchScreen.dart';

class Routes {
  static Route<dynamic>? fn(RouteSettings settings) {
    final Map<String, dynamic> arguments;
    if (settings.arguments == null) {
      arguments = {};
    } else {
      arguments = settings.arguments as Map<String, dynamic>;
    }

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => HomePage());

      case '/buildNewsDetails':
        return MaterialPageRoute(
            builder: (context) =>
                BuildNewsDetails(article: arguments["article"]));

      case '/search':
        return MaterialPageRoute(
            builder: (context) => SeacrhScreen() );          
    }
  }
}
