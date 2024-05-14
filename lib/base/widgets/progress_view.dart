import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class ProgressView extends StatelessWidget {

  final Color? color;

  const ProgressView({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? (primaryColor),
      ),
    );
  }
}