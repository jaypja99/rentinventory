
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../Utils/shared_pref_utils.dart';
import '../../../base/bloc/base_bloc.dart';
import '../../../base/constants/app_widgets.dart';

class RentFormScreenBloc extends BasePageBloc {

  Future<void> AddInventory(
      TextEditingController serialNumberController,
      TextEditingController nameController,
      Uint8List? imageData,
      BuildContext context) async {
    try {
      showLoadingDialog();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('inventory')
          .doc(getHospitalName())
          .collection('items')
          .where('serialNumber', isEqualTo: serialNumberController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        showMessageBar(
            "Inventory with this serial number already exists", Colors.deepOrangeAccent);
      } else {
        String imageDataString = base64Encode(imageData!);

        await FirebaseFirestore.instance
            .collection('inventory')
            .doc(getHospitalName())
            .collection('items')
            .add({
          'serialNumber': serialNumberController.text,
          'name': nameController.text,
          'imageUrl': imageDataString,
        });
        hideLoadingDialog();
        showMessageBar("Inventory added successfully");
      }
    } catch (e) {
      hideLoadingDialog();

      showMessageBar("Failed to add inventory", Colors.redAccent);
    } finally {
      Navigator.of(context).pop();
    }
  }

}
