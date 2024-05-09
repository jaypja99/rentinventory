import 'package:rxdart/rxdart.dart';

import 'base/src_bloc.dart';

class AppBloc extends BasePageBloc {
  late BehaviorSubject<bool> refreshProfile;

  late BehaviorSubject<String> cartRefresh;

  String? visitAmount;
  String? visitTax;

  AppBloc() {
    refreshProfile = BehaviorSubject.seeded(true);
    cartRefresh = BehaviorSubject<String>.seeded("");
  }

  void updateProfile(){
    if(!refreshProfile.isClosed){
      refreshProfile.add(true);
    }
  }

  void cartClear(){
    visitAmount = "";
    visitTax = "";
  }

  @override
  void dispose() {
    refreshProfile.close();
    cartRefresh.close();
  }
}
