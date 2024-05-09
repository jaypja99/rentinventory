import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:rentinventory/Screens/login/login_screen.dart';
import 'package:rentinventory/Utils/sp_util.dart';

import '../base/constants/app_widgets.dart';

const String keyLogin = "login";
const String keyAdmin = "admin";
const String keyFirebaseToken = "firebasetoken";
const String keyUserName = "username";
const String keyUserEmail = "useremail";
const String keyUserRole = "userrole";
const String keyHospitalName = "hospitalname";

void onLogout() {
  setLogin(false);
  setFirebaseToken("");
  Navigator.pushAndRemoveUntil(globalContext, LoginScreen.route(), (route) => false);
}


/// Username
void setUserName(String name) {
  SpUtil.putString(keyUserName, name);
}

String getUserName() {
  return SpUtil.getString(keyUserName, defValue: "");
}


/// User Email
void setUserEmail(String email) {
  SpUtil.putString(keyUserEmail, email);
}

String getUserEmail() {
  return SpUtil.getString(keyUserEmail, defValue: "");
}

/// User Email
void setHospitalName(String hospital) {
  SpUtil.putString(keyHospitalName, hospital);
}

String getHospitalName() {
  return SpUtil.getString(keyHospitalName, defValue: "");
}



/// User Email
void setUserRole(String role) {
  SpUtil.putString(keyUserRole, role);
}

String getUserRole() {
  return SpUtil.getString(keyUserRole, defValue: "");
}




/// Firebase Token
void setFirebaseToken(String token) {
  SpUtil.putString(keyFirebaseToken, token);
}

String getFirebaseToken() {
  return SpUtil.getString(keyFirebaseToken, defValue: "");
}

/// Login
void setLogin(bool isLogin) {
  SpUtil.putBool(keyLogin, isLogin);
}

bool isLogin() {
  return SpUtil.getBool(keyLogin, defValue: false);
}

/// Login
void setAdmin(bool isAdmin) {
  SpUtil.putBool(keyAdmin, isAdmin);
}

bool isAdmin() {
  return SpUtil.getBool(keyAdmin, defValue: false);
}
