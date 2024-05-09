import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../base/constants/app_colors.dart';
import '../base/constants/app_styles.dart';

class CommonAppUpdateDialog {
  static void show(BuildContext context, String? errorMessage) {
    Widget cancelButton = TextButton(
      child: Text('Cancel',
          style: styleMedium1.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          )),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
        child: Text('Update',
            style: styleMedium1.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w600,
            )),
        onPressed: () {
          if (Platform.isAndroid) {
            launch(
                "https://play.google.com/store/apps/details?id=com.jchi.customer&hl=en_IN&gl=US");
          } else if (Platform.isIOS) {
            launch("https://apps.apple.com/in/app/hitachi-india-customer-care/id1213257368");
          }
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Hitachi Customer',
          style: styleMedium4.copyWith(
            color: black,
            fontWeight: FontWeight.w600,
          )),
      content: Text(errorMessage ?? "",
          style: styleMedium1.copyWith(
            color: black,
            fontWeight: FontWeight.w500,
          )),
      contentPadding: EdgeInsets.fromLTRB(25, 25, 25, 0),
      titlePadding: EdgeInsets.fromLTRB(25, 25, 25, 0),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
