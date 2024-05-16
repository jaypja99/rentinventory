
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../Utils/shared_pref_utils.dart';
import '../../../base/bloc/base_bloc.dart';
import '../../../base/constants/app_widgets.dart';

class RentFormScreenBloc extends BasePageBloc {

  final _rentStreamController = StreamController<QuerySnapshot>();

  Stream<QuerySnapshot> get rentStream => _rentStreamController.stream;

  void getInventoryData() {
    FirebaseFirestore.instance.collection('rents').doc(getHospitalName()).collection('items').snapshots().listen((snapshot) {
      _rentStreamController.add(snapshot);
    });
  }

  Future<void> addRentData(Map<String, dynamic> rentData) async {
    try {
      await FirebaseFirestore.instance
          .collection('rents')
          .doc(getHospitalName())
          .collection('items')
          .add(rentData);
    } catch (e) {
      print('Error adding rent data: $e');
      // Handle error as needed
    }
  }



}
