import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/provider/newsProvider.dart';
import 'package:newsapp/provider/searchNewsProvider.dart';
import 'package:newsapp/routes.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(), // Wrap your app
      ),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(433, 921),
      builder: () => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => NewsProvider()),
            ChangeNotifierProvider(create: (_) => SearchNewsProvider()),
          ],
          child: Portal(
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: DevicePreview.locale(context), // Add the locale here
                builder: DevicePreview.appBuilder,
                title: 'News App',
                onGenerateRoute: Routes.fn,
                theme: ThemeData(
                    fontFamily: "Helvetica",
                    buttonColor: CustomColors.primaryNavyBlue)),
          )),
    );
  }
}
