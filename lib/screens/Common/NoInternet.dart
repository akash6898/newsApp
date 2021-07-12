import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class NoInternet extends StatelessWidget {
  NoInternet({required this.onRetry});
  VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageIcon(
            AssetImage("images/404.png"),
            size: 40,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "No Internet Connetion!",
            style: TextStyle(
                fontSize: 24,
                color: CustomColors.primaryNavyBlue,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(
              "Try Again",
              style: TextStyle(
                  fontSize: 15,
                  color: CustomColors.secondaryWhite,
                  fontWeight: FontWeight.w500),
            ),
            style: ElevatedButton.styleFrom(primary: CustomColors.primaryBlue),
          )
        ],
      ),
    );
  }
}
