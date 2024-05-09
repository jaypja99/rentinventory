import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Items in Inventory: 100'),
                    Text('Items Rented Out: 20'),
                    Text('Revenue Generated: \$1000'),
                    // Add more summary statistics as needed
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Action to add a new inventory item
              },
              child: Text('Add New Inventory Item'),
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
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: Text('Patient Name: John Doe'),
                      subtitle: Text('Item: Wheelchair | Start Date: 04/25/2024 | End Date: 05/05/2024'),
                    ),
                    ListTile(
                      title: Text('Patient Name: Jane Smith'),
                      subtitle: Text('Item: Crutches | Start Date: 04/28/2024 | End Date: 05/10/2024'),
                    ),
                    // Add more upcoming rentals as needed
                  ],
                ),
              ),
            ),
            // Add more components such as notifications, recent activity log, etc.
          ],
        ),
      ),
    );
  }
}
