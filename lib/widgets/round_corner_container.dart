import 'package:flutter/material.dart';

import '../base/constants/app_colors.dart';

class RoundedCornerContainer extends StatelessWidget {

  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;

  const RoundedCornerContainer({Key? key,this.child,this.padding,this.margin,this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(0),
      margin: margin ?? const EdgeInsets.all(0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30)),
        color: white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(101, 114, 178, 0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, -3), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}