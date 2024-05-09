import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Utils/date_util.dart';
import '../../base/bloc/base_bloc.dart';
import '../../base/constants/app_widgets.dart';

class AddHospitalScreenBloc extends BasePageBloc {
  AddHospitalScreenBloc();

  final _hospitalStreamController = StreamController<QuerySnapshot>();

  Stream<QuerySnapshot> get hospitalStream => _hospitalStreamController.stream;

  void addUserData(
      String name,
      String email,
      String password,
      String role,
      String? hospitalName,
      String? address,
      ) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final now = DateTime.now();
      final formattedDate = DateFormat('dd-MM-yyyy').format(now);

      final userData = {
        'name': name,
        'password': password,
        'role': role,
        'createdAt': formattedDate, // Add created date
        'hospitalName': hospitalName ?? '',
        'address': address ?? '',
        'loginAccessEmail': email, // New field for user login access email
      };

      // Create Firebase user
      final authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if user was added successfully
      if (authResult.user != null) {
        // Add user data to Firestore
        await firestoreInstance.collection('users').add(userData);
        showMessageBar('User added successfully');
      } else {
        showMessageBar('Failed to add user. Please try again.');
      }
    } catch (e) {
      // Handle errors
      print('Failed to add user data: $e');
      showMessageBar('Failed to add user data: $e'); // Show error message
    }
  }



  void getHospitalData() {
    FirebaseFirestore.instance.collection('users').snapshots().listen((snapshot) {
      _hospitalStreamController.add(snapshot);
    });
  }

  void deleteUser(DocumentSnapshot document) async {
    try {
      final userData = document.data() as Map<String, dynamic>;
      final loginAccessEmail = userData['loginAccessEmail'];

      // Delete user document from Firestore
      await document.reference.delete();

      // Delete user from Firebase Authentication
      final user = await FirebaseAuth.instance.currentUser;
      if (user != null && user.email == loginAccessEmail) {
        await user.delete();
      }

      showMessageBar('User deleted successfully'); // Show success message
    } catch (e) {
      print('Failed to delete user: $e');
      showMessageBar('Failed to delete user: $e'); // Show error message
    }
  }

  void deleteSelectedUsers(List<DocumentSnapshot> selectedDocuments) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      for (final doc in selectedDocuments) {
        final userData = doc.data() as Map<String, dynamic>;
        final loginAccessEmail = userData['loginAccessEmail'];
        batch.delete(doc.reference);

        // Delete user from Firebase Authentication
        final user = await FirebaseAuth.instance.currentUser;
        if (user != null && user.email == loginAccessEmail) {
          await user.delete();
        }
      }
      await batch.commit();
      selectedDocuments.clear();
      showMessageBar('Selected Users deleted successfully'); // Show success message
    } catch (e) {
      print('Failed to delete selected users: $e');
      showMessageBar('Failed to delete selected users: $e'); // Show error message
    }
  }

  @override
  void dispose() {
    _hospitalStreamController.close();
  }
}
