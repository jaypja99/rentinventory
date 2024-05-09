import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPageRoute<T> extends CupertinoPageRoute<T> {
  CustomPageRoute({ required WidgetBuilder builder, RouteSettings? settings })
      : super(builder: builder, settings: settings);

/*@override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }*/
}