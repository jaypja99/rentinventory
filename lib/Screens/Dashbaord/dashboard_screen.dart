import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentinventory/Screens/AddUserScreen/add_user_screen.dart';
import 'package:rentinventory/Screens/Dashbaord/dashboard_screen_bloc.dart';
import 'package:rentinventory/Screens/HomeScreen/Homescreen.dart';
import 'package:rentinventory/Screens/RentScreen/add_rent_screen.dart';
import 'package:rentinventory/Utils/shared_pref_utils.dart';
import 'package:rentinventory/base/bloc/base_bloc.dart';

import '../../base/basePage.dart';
import '../../base/widgets/custom_page_route.dart';
import '../InventoryFormScreen/add_Inventory_screen.dart';
import 'navigation_drawer.dart';
import 'profileWidget.dart';

class DashboardScreen extends BasePage<DashboardScreenBloc> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  BasePageState<BasePage<BasePageBloc?>, BasePageBloc> getState() {
    return _DashboardScreenState();
  }

  static Route<dynamic> route() {
    return CustomPageRoute(builder: (context) => DashboardScreen());
  }
}

class _DashboardScreenState
    extends BasePageState<DashboardScreen, DashboardScreenBloc> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  late PageController _pageController;
  final List<String> _adminPageTitles = [
    'Dashboard',
    'Add User',
    'Rent History'
  ];
  final List<String> _hospitalPageTitles = [
    'Dashboard',
    'Add Inventory',
    'Give Rent',
    'Rent History'
  ];
  DashboardScreenBloc bloc = DashboardScreenBloc();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController
          .jumpToPage(index); // Jump to the selected page without animation
    });
  }

  Future<String> signOut() async {
    await _auth.signOut();
    onLogout();
    return 'User signed out';
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        NavigationDrawerMenu(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
          logo: Image.asset(
            'assets/images/inventory.png',
            // Adjust the path to your logo image
            height: 40, // Adjust the height of the logo
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppBar(
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    isAdmin()
                        ? _adminPageTitles[_selectedIndex]
                        : _hospitalPageTitles[_selectedIndex],
                    style: GoogleFonts.raleway(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                actions: [ProfileWidget()],
              ),
              Expanded(
                child: PageView(
                  allowImplicitScrolling: false,
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  children: [
                    HomeScreen(),
                    if (isAdmin() != true) AddInventoryScreen(),
                    if (isAdmin() == true) AddUserScreen(),
                    // Conditionally add AddHospitalScreen based on isAdmin
                    if (isAdmin() != true) AddRentScreen(),
                    Container(
                      color: Colors.white,
                      child: Center(
                        child: Text('Rent'),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Center(
                        child: Text('Rent History'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  @override
  DashboardScreenBloc getBloc() {
    return bloc;
  }
}
