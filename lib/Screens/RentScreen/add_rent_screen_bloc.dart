import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Utils/shared_pref_utils.dart';
import '../../base/bloc/base_bloc.dart';

class AddRentScreenBloc extends BasePageBloc {
  AddRentScreenBloc();

  final _rentStreamController = StreamController<QuerySnapshot>();

  Stream<QuerySnapshot> get rentStream => _rentStreamController.stream;

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

  void getInventoryData() {
    FirebaseFirestore.instance.collection('rents').doc(getHospitalName()).collection('items').snapshots().listen((snapshot) {
      _rentStreamController.add(snapshot);
    });
  }


  @override
  void dispose() {
    _rentStreamController.close();
  }
}
