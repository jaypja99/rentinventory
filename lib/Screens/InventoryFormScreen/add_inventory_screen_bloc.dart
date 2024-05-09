import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Utils/shared_pref_utils.dart';
import '../../base/bloc/base_bloc.dart';


class AddInventoryScreenBloc extends BasePageBloc {
  AddInventoryScreenBloc();

  final _inventorylStreamController = StreamController<QuerySnapshot>();

  Stream<QuerySnapshot> get inventoryStream => _inventorylStreamController.stream;


  void getInventoryData() {
    FirebaseFirestore.instance.collection('inventory').doc(getHospitalName()).collection('items').snapshots().listen((snapshot) {
      _inventorylStreamController.add(snapshot);
    });
  }




}
