import 'package:flutter/material.dart';
import 'package:rentinventory/base/components/screen_utils/flutter_screenutil.dart';

import '../src_constants.dart';

enum _QuickViewType { error, empty }

/// A [QuickView] widget that provides out-of-the-box implementation
/// for quick and simple use cases.
class QuickView extends StatelessWidget {
  final _QuickViewType? type;
  final String? title;
  final Function()? onRetry;
  final Color? textColor;
  final double? textSize;

  const QuickView._({
    this.type,
    this.title,
    this.onRetry,
    this.textColor,
    this.textSize
  });

  factory QuickView.error({
    String? title,
    Function()? onRetry,
    String? retryText,
    Color? textColor,
    double? textSize
  }) {
    return QuickView._(
      type: _QuickViewType.error,
      title: title,
      onRetry: onRetry,
      textColor : textColor,
      textSize: textSize,
    );
  }

  factory QuickView.empty({String? title,Color? textColor,double? textSize}) {
    return QuickView._(
      type: _QuickViewType.empty,
      title: title,
      textColor: textColor,
      textSize: textSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = title == null
        ? Container()
        : Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(title!,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: textSize ?? 20.sp,
                fontWeight: FontWeight.w500,
                fontFamily: fontFamilySourceSansPro,
                color: textColor),
            textAlign: TextAlign.center),
      ),
    );
    final r = onRetry == null
        ? Container()
        : button();

    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    t,
                    const SizedBox(height: 8),
                    r,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget button(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        shadowColor: accentColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22)
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 32),
        child:  Text(
          "Retry",
          maxLines: 1,
          style: styleMedium1.copyWith(
              color: white
          ),
        ),
      ),
      onPressed: onRetry,
    );
  }
}

class QuickCustomView extends StatelessWidget {
  final _QuickViewType? type;
  final String? title;
  final Function()? onRetry;
  final Color? textColor;
  final double? textSize;

  const QuickCustomView._({
    this.type,
    this.title,
    this.onRetry,
    this.textColor,
    this.textSize
  });

  factory QuickCustomView.error({
    String? title,
    Function()? onRetry,
    String? retryText,
    Color? textColor,
    double? textSize
  }) {
    return QuickCustomView._(
      type: _QuickViewType.error,
      title: title,
      onRetry: onRetry,
      textColor : textColor,
      textSize: textSize,
    );
  }

  factory QuickCustomView.empty({String? title,Color? textColor,double? textSize}) {
    return QuickCustomView._(
      type: _QuickViewType.empty,
      title: title,
      textColor: textColor,
      textSize: textSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = title == null
        ? Container()
        : Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Center(
        child: Text(title!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: textSize ?? 18.sp,
                fontWeight: FontWeight.w500,
                fontFamily: fontFamilySourceSansPro,
                color: textColor),
            textAlign: TextAlign.center),
      ),
    );
    final r = onRetry == null
        ? Container()
        : button();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          t,
          const SizedBox(height: 8),
          r,
        ],
      ),
    );
  }

  Widget button(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        shadowColor: accentColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22)
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 28),
        child:  Text(
          "Retry",
          maxLines: 1,
          style: styleSmall4.copyWith(
              color: white
          ),
        ),
      ),
      onPressed: onRetry,
    );
  }
}

class PlaceHolderView {
  final String? title;
  final Function()? onRetry;

  PlaceHolderView({this.title = "", this.onRetry});
}
