import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      color: Color(0xFF1E1F1E), // Use #1e1f1e color
      child: Drawer(
        backgroundColor: Color(0xFF1E1F1E), // Use #1e1f1e color
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.all(30),
              child: logo,
              decoration: BoxDecoration(
                color: Color(0xFF1E1F1E), // Use #1e1f1e color
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
                Radius.circular(8),
              ),
              color: isSelected ? Colors.blueAccent : Colors.transparent,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                            0.3), // Add a shadow to the selected tile
                        blurRadius: 1,
                        spreadRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: ListTile(
              leading: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
              ),
              title: Text(
                title,
                style: TextStyle(
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
                    Radius.circular(8),
                  ),
                ),
              ),
            ),
          if (isSelected)
            Positioned(
              right: 10, // Adjust this value to 20 pixels from the right end
              bottom: 10,
              top: 10,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(2),
                    right: Radius.circular(2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
