import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/shared_pref_utils.dart';

class NavigationDrawerMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Image logo;

  NavigationDrawerMenu(
      {required this.selectedIndex,
      required this.onItemTapped,
      required this.logo});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2F2F2F), // Use #1e1f1e color
      child: Drawer(
        backgroundColor: Color(0xFF2F2F2F), // Use #1e1f1e color
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(

              curve: Curves.ease,
              padding: EdgeInsets.all(30),
              child: logo,
              decoration: BoxDecoration(
                color: Color(0xFF2F2F2F), // Use #1e1f1e color
              ),
            ),
            isAdmin() ?
            buildAdminListTile() : buildHospitalListTile()
          ],
        ),
      ),
    );
  }

  Widget buildAdminListTile() {
    return Column(
      children: [
        buildListTile(Icons.home, 'Home', 0),
        buildListTile(Icons.local_hospital, 'Add Users', 1),
        buildListTile(Icons.history, 'Rent History', 2),
      ],
    );
  }

  Widget buildHospitalListTile() {
    return Column(
      children: [
        buildListTile(Icons.home, 'Home', 0),
        buildListTile(Icons.inventory, 'Add Inventory', 1),
        buildListTile(Icons.supervised_user_circle_sharp, 'Give Rent', 2),
        buildListTile(Icons.history, 'Rent History', 3),
      ],
    );
  }

  Widget buildListTile(IconData icon, String title, int index) {
    final isSelected = selectedIndex == index;
    final hoverColor = Colors.blue.withOpacity(0.2);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              color: isSelected ? Colors.blueAccent : Colors.transparent,

            ),
            child: ListTile(
              leading: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
              ),
              title: Text(
                title,
                style: GoogleFonts.raleway(
                  color: isSelected ? Colors.white : Colors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              selected: isSelected,
              hoverColor: hoverColor,

              onTap: () => onItemTapped(index),
            ),
          ),
          if (!isSelected)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onItemTapped(index),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
