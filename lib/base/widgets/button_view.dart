import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../src_constants.dart';

class ButtonView extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final Color? disableColor;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final double radius;
  final bool disable;
  final AlignmentGeometry alignment;
  final Widget? postfix;
  final double height;
  final double width;
  final double minWidth;
  final TextStyle? textStyle;
  final VoidCallback? isForceClick;
  final double? borderWidth;
  final Color? borderColor;

  const ButtonView(this.text, this.onPressed,
      {Key? key, this.color = primaryColor,
      this.textColor,
      this.disableColor,
      this.height = 50,
      this.width = double.infinity,
      this.minWidth = double.infinity,
      this.radius = 5,
      this.textStyle,
      this.disable = false,
      this.borderColor,
      this.borderWidth,
      this.alignment = Alignment.center,
      this.postfix,
      this.isForceClick,
      this.padding = const EdgeInsets.symmetric(horizontal: 16)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ButtonTheme(
        child: MaterialButton(
            elevation: 0,
            padding: padding,
            height: height,
            color: disable
                ? (disableColor ?? black.withOpacity(0.5))
                : (color ?? buttonColor),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius)),
                side: BorderSide(color: borderColor ?? Colors.transparent, width: borderWidth ?? 0.0)),
            child: Container(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                      alignment: alignment,
                      child: Text(text,
                          maxLines: 1,
                          style: textStyle ?? GoogleFonts.raleway(color: textColor ?? white,  fontWeight: FontWeight.w700,
                            fontSize: 14))),
                  postfix == null
                      ? const SizedBox()
                      : Container(margin: const EdgeInsets.only(left: 12), child: postfix)
                ],
              ),
            ),
            onPressed: isForceClick ?? (disable ? () => null : onPressed)),
      ),
    );
  }
}
