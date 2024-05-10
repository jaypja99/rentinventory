import 'package:ez_localization/ez_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rentinventory/Screens/Dashbaord/dashboard_screen.dart';
import 'package:rentinventory/Screens/login/login_screen.dart';
import 'package:rentinventory/Utils/shared_pref_utils.dart';
import 'package:rentinventory/base/bloc/base_bloc_provider.dart';
import 'package:uuid/uuid.dart';

import 'Utils/sp_util.dart';
import 'app_bloc.dart';
import 'base/components/loader_overlay/ots.dart';
import 'base/components/screen_utils/flutter_screenutil.dart';
import 'base/constants/app_themes.dart';
import 'base/constants/app_widgets.dart';

var uuid = const Uuid();

Future<void> setFirebaseInit() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyApVEaw2dKXG27iQrFLshn1Z04KFwYsV_g",
          authDomain: "flutter-web-app-inventory.firebaseapp.com",
          projectId: "flutter-web-app-inventory",
          storageBucket: "flutter-web-app-inventory.appspot.com",
          messagingSenderId: "942758742741",
          appId: "1:942758742741:web:92391b3b6d2d168399b05c",
          measurementId: "G-747378DG8D"),
    );
  } else {
    await Firebase.initializeApp();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;

  ///Shared Preferences
  await SpUtil.getInstance();

  await setFirebaseInit();

  ///Set Portrait
  runApp(BlocProvider<AppBloc>(initBloc: AppBloc(), child: const MyHomePage()));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return OTS(
      child: EzLocalizationBuilder(
        delegate: const EzLocalizationDelegate(
            supportedLocales: [Locale('en')], locale: Locale("en")),
        builder: (BuildContext context,
            EzLocalizationDelegate ezLocalizationDelegate) {
          return ScreenUtilInit(
            builder: () => MaterialApp(
              builder: (context, child) {
                return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: child!);
              },
              debugShowCheckedModeBanner: false,
              title: 'Rental ',
              theme: lightTheme(context),
              home: isLogin() ? DashboardScreen() : LoginScreen(),
              navigatorKey: navigatorKey,
              localizationsDelegates:
                  ezLocalizationDelegate.localizationDelegates,
              supportedLocales: ezLocalizationDelegate.supportedLocales,
              localeResolutionCallback:
                  ezLocalizationDelegate.localeResolutionCallback,
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
}
