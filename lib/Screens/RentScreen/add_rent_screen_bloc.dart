import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../base/bloc/base_bloc.dart';

class AddRentScreenBloc extends BasePageBloc {
  AddRentScreenBloc();

  final _rentStreamController = StreamController<QuerySnapshot>();

  Stream<QuerySnapshot> get rentStream => _rentStreamController.stream;

  @override
  void dispose() {
    _rentStreamController.close();
  }
}
