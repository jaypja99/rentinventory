import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../base/constants/app_colors.dart';
import '../base/constants/app_images.dart';
import '../base/constants/app_styles.dart';




Widget buildHomeAppBar({Function()? onPrivacyClick,Function()? onNotificationClick,Function()? onLogout}){
  return AppBar(
    centerTitle: true,
    backgroundColor: primaryColor,
    automaticallyImplyLeading: false,
    title: SvgPicture.asset(
      AppImages.icHitachiLogo,
      color: white,
      height: 18,
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 14),
        child: Row(
          children: [
            /*InkWell(
              onTap: onPrivacyClick,
              child: SvgPicture.asset(
                AppImages.icPrivacy,
                color: white,
                height: 24,
              ),
            ),*/
            //const SizedBox(width: 16),
            InkWell(
              onTap: onNotificationClick,
              child: SvgPicture.asset(
                AppImages.icNotification,
                color: white,
                height: 24,
              ),
            ),
            const SizedBox(width: 20),
            InkWell(
              onTap: onLogout,
              child: SvgPicture.asset(
                  AppImages.icLogout,
                  color: white,
                  height: 24,
              ),
            ),

          ],
        ),
      ),
    ],
  );
}

Widget buildBackAppBar(String title,{Function()? onBackClick,List<Widget>? actions}){
  return AppBar(
    backgroundColor: primaryColor,
      centerTitle: false,
    leading: InkWell(
      onTap: onBackClick,
      child: const Icon(
        Icons.arrow_back_ios,
        size: 20,
        color: white,
      ),
    ),
    automaticallyImplyLeading: false,
    title: Text(
      title,
      style: styleMedium4.copyWith(color: white, fontWeight: FontWeight.w400),
      textAlign: TextAlign.start,
    ),
    actions: actions
  );
}