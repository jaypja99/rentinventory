import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('Total Items in Inventory', '100'),
                _buildStatCard('Items Rented Out', '20'),
                _buildStatCard('Revenue Generated', '\$1000'),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Action to add a new inventory item
              },
              child: Text(
                'Add New Inventory Item',
                style: GoogleFonts.raleway(),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Rentals',
                      style: GoogleFonts.raleway(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: Text(
                        'Patient Name: John Doe',
                        style: GoogleFonts.raleway(),
                      ),
                      subtitle: Text(
                        'Item: Wheelchair | Start Date: 04/25/2024 | End Date: 05/05/2024',
                        style: GoogleFonts.raleway(),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Patient Name: Jane Smith',
                        style: GoogleFonts.raleway(),
                      ),
                      subtitle: Text(
                        'Item: Crutches | Start Date: 04/28/2024 | End Date: 05/10/2024',
                        style: GoogleFonts.raleway(),
                      ),
                    ),
                    // Add more upcoming rentals as needed
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Rent Additions',
                      style: GoogleFonts.raleway(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: Text(
                        'Patient Name: Jack Johnson',
                        style: GoogleFonts.raleway(),
                      ),
                      subtitle: Text(
                        'Item: Hospital Bed | Start Date: 05/01/2024 | End Date: 05/15/2024',
                        style: GoogleFonts.raleway(),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Patient Name: Emma Wilson',
                        style: GoogleFonts.raleway(),
                      ),
                      subtitle: Text(
                        'Item: Walker | Start Date: 04/30/2024 | End Date: 05/10/2024',
                        style: GoogleFonts.raleway(),
                      ),
                    ),
                    // Add more recent rent additions as needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.raleway(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.raleway(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

