import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentinventory/widgets/round_corner_container.dart';

/// Displays Material dialog above the current contents of the app

class DialogWidget extends StatelessWidget {
  const DialogWidget({
    Key? key,
    this.title,
    this.msg,
    this.actions,
    this.customView = const SizedBox(),
    this.titleStyle,
    this.msgStyle,
    this.titleAlign,
    this.msgAlign,
    this.dialogWidth,
    this.color,
  }) : super(key: key);

  /// [actions]Widgets to display a row of buttons after the [msg] widget.
  final List<Widget>? actions;

  /// [customView] a widget to display a custom widget instead of the animation view.
  final Widget customView;

  /// [title] your dialog title
  final String? title;

  /// [msg] your dialog description message
  final String? msg;


  /// [titleStyle] dialog title text style
  final TextStyle? titleStyle;

  /// [animation] lottie animations path
  final TextStyle? msgStyle;

  /// [titleAlign] dialog title text alignment
  final TextAlign? titleAlign;

  /// [textAlign] dialog description text alignment
  final TextAlign? msgAlign;

  /// [color] dialog's backgorund color
  final Color? color;

  /// [dialogWidth] dialog's width compared to the screen width
  final double? dialogWidth;

  @override
  Widget build(BuildContext context) {
    return RoundedCornerContainer(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          customView,
          title != null
              ? Padding(
            padding:
            const EdgeInsets.only(right: 20, left: 20, top: 24.0),
            child: Text(
              title!,
              style: titleStyle,
              textAlign: titleAlign,
            ),
          )
              : const SizedBox(
            height: 4,
          ),
          msg != null
              ? Padding(
            padding:
            const EdgeInsets.only(right: 20, left: 20, top: 16.0),
            child: Text(
              msg!,
              style: msgStyle,
              textAlign: msgAlign,
            ),
          )
              : const SizedBox(
            height: 20,
          ),
          actions?.isNotEmpty == true
              ? buttons(context)
              : const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget buttons(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(right: 20, left: 20, top: 16.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(actions!.length, (index) {
          final TextDirection direction = Directionality.of(context);
          double padding = index != 0 ? 8 : 0;
          double rightPadding = 0;
          double leftPadding = 0;
          direction == TextDirection.rtl
              ? rightPadding = padding
              : leftPadding = padding;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
              child: actions![index],
            ),
          );
        }),
      ),
    );
  }
}
