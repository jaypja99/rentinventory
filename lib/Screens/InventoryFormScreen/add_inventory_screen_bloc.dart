import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Utils/shared_pref_utils.dart';
import '../../base/bloc/base_bloc.dart';


class AddInventoryScreenBloc extends BasePageBloc {
  AddInventoryScreenBloc();

  final _inventorylStreamController = StreamController<QuerySnapshot>();
  final _scannedCodeController = StreamController<String>(); // Controller for scanned code


  Stream<QuerySnapshot> get inventoryStream => _inventorylStreamController.stream;
  Stream<String> get scannedCodeStream => _scannedCodeController.stream; // Expose scanned code stream


  void getInventoryData() {
    FirebaseFirestore.instance.collection('inventory').doc(getHospitalName()).collection('items').snapshots().listen((snapshot) {
      _inventorylStreamController.add(snapshot);
    });
  }

  void addScannedCode(String code) {
    _scannedCodeController.add(code); // Add scanned code to the stream
  }

  void disposeScannedCode(){
    _scannedCodeController.close();
}

  @override
  void dispose() {
    _inventorylStreamController.close();
    _scannedCodeController.close();
  }
}

