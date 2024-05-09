import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rentinventory/Screens/Dashbaord/dashboard_screen.dart';
import 'package:rentinventory/Utils/shared_pref_utils.dart';
import 'package:rentinventory/base/constants/app_widgets.dart';

import '../../base/basePage.dart';
import '../../base/bloc/base_bloc.dart';
import '../../base/widgets/button_view.dart';
import '../../base/widgets/custom_page_route.dart';
import 'login_screen_bloc.dart';


class LoginScreen extends BasePage<LoginScreenBloc> {

  const LoginScreen({super.key});

  @override
  BasePageState<BasePage<BasePageBloc?>, BasePageBloc> getState() {
    return _LoginScreenState();
  }

  static Route<dynamic> route() {
    return CustomPageRoute(
        builder: (context) => LoginScreen());
  }
}

class _LoginScreenState extends BasePageState<LoginScreen, LoginScreenBloc> {
  LoginScreenBloc bloc = LoginScreenBloc();

  final TextEditingController _usernameController  = TextEditingController();
  final TextEditingController _passwordController  = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? uid;
  String? userEmail;


  @override
  LoginScreenBloc getBloc() {
    return bloc;
  }

  @override
  void onReady() {

  }

  @override
  Widget buildWidget(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width/2),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(50),
                      child: Column(
                        mainAxisSize: MainAxisSize.max, // Set mainAxisSize to min
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          // submitButton("Register",(){
                          //   registerWithEmailPassword(_usernameController.text, _passwordController.text);
                          // }),
                          submitButton("Login",(){
                            signInWithEmailPassword(_usernameController.text, _passwordController.text);
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget submitButton(String title, void Function() onClick) {
    return ButtonView(title, onClick);
  }


  Future<User?> registerWithEmailPassword(String email, String password) async {
    // Initialize Firebase
    await Firebase.initializeApp();
    User? user;

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;

      if (user != null) {
        uid = user.uid;
        userEmail = user.email;
        print('Registration Successful');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('An account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user;
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    await Firebase.initializeApp();
    User? user;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;

      if (user != null) {
        uid = user.uid;
        userEmail = user.email;

        // Fetch user data from Firestore
        final userData = await getUserData(email);
        if (userData != null) {
          // Save user data to preferences
          saveUserDataToPrefs(userData);
        }

        setLogin(true);
        showMessageBar('Login Successfully');
        showMessageBar(user.getIdToken().toString());
        Navigator.pushAndRemoveUntil(globalContext, DashboardScreen.route(), (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      setLogin(false);
      showMessageBar(e.message.toString());

      if (e.code == 'user-not-found') {
        showMessageBar('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showMessageBar('Wrong password provided.');
      }
    }

    return user;
  }

  Future<Map<String, dynamic>?> getUserData(String email) async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('users').where('loginAccessEmail', isEqualTo: email).get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      } else {
        showMessageBar('User data not found in Firestore for email: $email');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      showMessageBar('Error fetching user data');
      return null;
    }
  }

  void saveUserDataToPrefs(Map<String, dynamic> userData) {
    setUserName(userData['name']);
    setUserRole(userData['role']);
    setUserEmail(userData['loginAccessEmail']);
    setHospitalName(userData['hospitalName']);
    print(getUserRole());
    getUserRole() == 'admin' ? setAdmin(true) : setAdmin(false);
        // Add more data as needed
  }





}
