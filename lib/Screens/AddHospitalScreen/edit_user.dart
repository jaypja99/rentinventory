import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditUserPopupForm extends StatefulWidget {
  final DocumentSnapshot userDocument;

  const EditUserPopupForm({Key? key, required this.userDocument}) : super(key: key);

  @override
  _EditUserPopupFormState createState() => _EditUserPopupFormState();
}

class _EditUserPopupFormState extends State<EditUserPopupForm> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userDocument['name']);
    _emailController = TextEditingController(text: widget.userDocument['loginAccessEmail']);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit User'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'loginAccessEmail'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _updateUserInAuthAndFirestore();
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }


  void _updateUserInAuthAndFirestore() {
    final String newName = _nameController.text;
    final String newEmail = _emailController.text;
    final String userId = widget.userDocument.id;

    _updateUserInAuth(newEmail, newName);
    _updateUserInFirestore(userId, newName, newEmail);
  }

  void _updateUserInAuth(String newEmail, String newName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateEmail(newEmail);
        await user.updateDisplayName(newName);
      }
    } catch (e) {
      print('Failed to update user in authentication: $e');
      // Handle error appropriately
    }
  }

  void _updateUserInFirestore(String userId, String newName, String newEmail) async {
    widget.userDocument.reference.update({
      'name': newName,
      'loginAccessEmail': newEmail,
      // Add more fields to update as needed
    });
  }



  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
