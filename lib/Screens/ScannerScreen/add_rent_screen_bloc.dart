import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Utils/date_util.dart';
import '../../base/bloc/base_bloc.dart';
import '../../base/constants/app_widgets.dart';

class AddRentScreenBloc extends BasePageBloc {
  AddRentScreenBloc();

  final _hospitalStreamController = StreamController<QuerySnapshot>();

  Stream<QuerySnapshot> get hospitalStream => _hospitalStreamController.stream;

  @override
  void dispose() {
    _hospitalStreamController.close();
  }
}
