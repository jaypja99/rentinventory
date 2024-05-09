
import 'package:flutter/material.dart';
import 'package:rentinventory/Screens/login/login_screen.dart';
import 'package:rentinventory/Utils/shared_pref_utils.dart';

class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    String userProfileImage = "assets/images/profile_pic.jpg"; // Replace with the path to the user's profile picture

    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(userProfileImage),
          radius: 20,
        ),
        SizedBox(width: 10),
        Text(
          "Hello, ${getUserName()}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 10),
        IconButton(
          icon: Icon(Icons.logout),
          color: Colors.black,
          onPressed: () {
            onLogout();
            Navigator.pushReplacement(context, LoginScreen.route());
          },
        ),
      ],
    );
  }
}