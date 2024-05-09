

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';


import '../base/constants/app_colors.dart';
import '../base/constants/app_styles.dart';
import '../base/constants/app_widgets.dart';
import '../base/src_utils.dart';
import '../base/widgets/appbar_view.dart';
import '../base/widgets/image_view.dart';
import '../utils/common_utils.dart';
import '../utils/shared_pref_utils.dart';
import 'dialog_widget.dart';

Widget buildCommonCard(Widget child,{ EdgeInsets margin = const EdgeInsets.all(0)}){
  return Card(
    color: white,
    margin: margin,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    child: Wrap(
      children: [
        child,
        const Divider(
          color: primaryColor,
          height: 1,
          thickness: 2,
        ),
      ],
    ),
  );
}

void showMenuOptions(){
  showModalBottomSheet<void>(
    isScrollControlled: true,
    context: globalContext,
    enableDrag: true,
    isDismissible: true,
    barrierColor: Colors.white.withOpacity(0.35),
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        // child: const OptionsScreen(),
      );
    },
  );
}

void showFilterOptions(Map filter,Function(Map)? onApplyFilter){
  showModalBottomSheet<void>(
    isScrollControlled: true,
    context: globalContext,
    enableDrag: true,
    isDismissible: true,
    barrierColor: Colors.white.withOpacity(0.35),
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        // child: FilterScreen(filter: filter,onApplyFilter: onApplyFilter),
      );
    },
  );
}

Widget buildAmount(String amount){
  return RawMaterialButton(
    constraints: const BoxConstraints(minWidth: 20.0, minHeight: 20.0),
    fillColor: secondaryColor,
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 6, horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            amount,
            maxLines: 1,
            style: styleSmall4.copyWith(
                color: white,
                fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    ),
    onPressed: null,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7)),
  );
}


Widget buildSquareButton({
  required String text,
  required VoidCallback onPressed,
  Color color = Colors.blueAccent,
  Color textColor = Colors.white,
  double borderRadius = 8.0,
  double? width,
  EdgeInsets? padding,
}) {
  return Container(
    width: width,
    padding: padding ?? EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3), // Add a shadow to the selected tile
          blurRadius: 1,
          spreadRadius: 1,
          offset: Offset(0, 1),
        ),
      ]
    ),

    child: TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    ),
  );
}

