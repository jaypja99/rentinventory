import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Utils/shared_pref_utils.dart';
import '../../base/bloc/base_bloc.dart';
import '../../base/constants/app_widgets.dart';

class AddInventoryScreenBloc extends BasePageBloc {
  AddInventoryScreenBloc();

  final _inventorylStreamController = StreamController<QuerySnapshot>();

  Stream<QuerySnapshot> get inventoryStream =>
      _inventorylStreamController.stream;

  void getInventoryData() {
    FirebaseFirestore.instance
        .collection('inventory')
        .doc(getHospitalName())
        .collection('items')
        .snapshots()
        .listen((snapshot) {
      _inventorylStreamController.add(snapshot);
    });
  }

  Future<void> updateInventoryItem(String documentId, Map<String, dynamic> newData) async {
    try {
      showLoadingDialog();
      await FirebaseFirestore.instance
          .collection('inventory') // Assuming 'inventory' is the root collection
          .doc(getHospitalName()) // Assuming 'getHospitalName()' returns the document ID of the hospital
          .collection('items') // Assuming 'items' is the subcollection containing inventory items
          .doc(documentId) // The document ID of the item to update
          .update(newData); // Update the document with new data
      hideLoadingDialog();
      showMessageBar("Inventory Updated Successfully");
    } catch (error) {
      print('Error updating inventory item: $error');
      hideLoadingDialog();

    }
  }

  Future<void> deleteSelectedInventoryItems(List<String> selectedDocumentIds) async {
    try {
      showLoadingDialog(); // Show loading indicator
      final batch = FirebaseFirestore.instance.batch(); // Create a batch

      // Iterate through each document ID and add delete operation to the batch
      for (final docId in selectedDocumentIds) {
        final docRef = FirebaseFirestore.instance
            .collection('inventory') // Root collection
            .doc(getHospitalName()) // Document ID of the hospital
            .collection('items') // Subcollection containing inventory items
            .doc(docId); // Document ID of the item to delete
        batch.delete(docRef); // Add delete operation to the batch
      }

      // Commit the batch operation
      await batch.commit();

      hideLoadingDialog(); // Hide loading indicator
      showMessageBar("Selected Inventory Items Deleted Successfully");
    } catch (error) {
      hideLoadingDialog();
    }
  }


  Future<void> deleteInventoryItem(String documentId) async {
    try {
      showLoadingDialog();
      await FirebaseFirestore.instance
          .collection('inventory')
          .doc(getHospitalName())
          .collection('items')
          .doc(documentId)
          .delete();

      showMessageBar("Inventory item deleted successfully");
      hideLoadingDialog();
    } catch (e) {
      hideLoadingDialog();
      showMessageBar("Failed to delete inventory item", Colors.redAccent);
    }
  }




  @override
  void dispose() {
    _inventorylStreamController.close();
  }
}
