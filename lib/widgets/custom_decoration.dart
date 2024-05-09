import 'package:flutter/material.dart';

import '../base/constants/app_colors.dart';
import '../base/constants/app_styles.dart';

InputDecoration getTextFieldBorderDecoration(String hint) {
  return InputDecoration(
      contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
      fillColor:  white,
      filled: true,
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: borderColor)
      ),
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red)
      ),
      focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: secondaryColor)
      ),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: black)
      ),
      disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: borderColor)
      ),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor)
      ),
      errorMaxLines: 2,
      isDense: true,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      errorStyle: const TextStyle(
        fontFamily: fontFamilySourceSansPro,
        color: Colors.red,
        fontSize: 12,
      ));
}

InputDecoration getTextFieldBorderLightGrayDecoration(String hint) {
  return InputDecoration(
      contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
      fillColor:  white,
      filled: true,
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: borderColor)
      ),
      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.red)
      ),
      focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: secondaryColor)
      ),
      enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: lightGray)
      ),
      disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: borderColor)
      ),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: lightGray)
      ),
      errorMaxLines: 2,
      isDense: true,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      errorStyle: const TextStyle(
        fontFamily: fontFamilySourceSansPro,
        color: Colors.red,
        fontSize: 12,
      ));
}
InputDecoration getTextFieldWithoutBorderDecoration(String hint) {
  return InputDecoration(
      contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
      fillColor:  white,
      filled: true,
      border: InputBorder.none,
      errorMaxLines: 2,
      isDense: true,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      errorStyle: const TextStyle(
        fontFamily: fontFamilySourceSansPro,
        color: Colors.red,
        fontSize: 12,
      ));
}