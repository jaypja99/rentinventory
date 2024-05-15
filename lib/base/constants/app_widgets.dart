import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../src_constants.dart';

/// to get main navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// to get all app context
final BuildContext globalContext = navigatorKey.currentState!.context;

/// base image asset
imageAsset(context, path, {width, height, color, fit = BoxFit.contain}) =>
    Image.asset("assets/images/$path",
        width: width, height: height, color: color, fit: fit);

/// base image asset
assetImage(context, path) => AssetImage('assets/images/$path');

/// hide keyboard
hideKeyboard(BuildContext context) =>
    FocusScope.of(context).requestFocus(FocusNode());

/// show const back arrow
backArrow(context, {onTap, arrowColor = black, path = 'left_arrow'}) {
  return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: imageAsset(context, path,
                  height: 20.0, width: 20.0, color: arrowColor ?? black))));
}

 showMessageBar(String message, [Color? color]) {
   ScaffoldMessenger.of(globalContext).showSnackBar( SnackBar(
    backgroundColor: color ?? Colors.black,

    duration: const Duration(seconds: 3),
    content: Text(
      message,
      maxLines: 3,
      style: TextStyle(color: Colors.white), // Adjust the style here
    ),
  ));
}

Future selectDate(context,Function(DateTime) selectedDate) async {
  DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030));
  if (picked != null) {
    selectedDate(picked);
  }
}
