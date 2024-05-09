import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentinventory/Utils/shared_pref_utils.dart';

class AddRentScreen extends StatefulWidget {
  const AddRentScreen({Key? key}) : super(key: key);

  @override
  _AddRentScreenState createState() => _AddRentScreenState();
}

class _AddRentScreenState extends State<AddRentScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _serialNumberController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  String? _selectedInventoryName;
  List<String> _inventoryNames = [];

  DateTime? _lastInputTime; // Track the time of the last input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Rent'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _selectedInventoryName,
                items: _inventoryNames
                    .map((name) => DropdownMenuItem<String>(
                  value: name,
                  child: Row(
                    children: [
                      _buildInventoryImage(name), // Function to build inventory image
                      SizedBox(width: 8),
                      Text(name),
                    ],
                  ),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedInventoryName = value;
                    // Fetch inventory details based on the selected name
                    _fetchInventoryDetailsByName(value!);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Inventory Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _serialNumberController,
                decoration: InputDecoration(
                  labelText: 'Serial Number',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // Check if input came from scanner or manual typing
                  _detectInputSource();
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                // Add more form fields
              ),
              SizedBox(height: 20),
              // Add more form fields here for Patient name, Chip id, etc.
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Patient Name',
                  border: OutlineInputBorder(),
                ),
                // Add validation logic if needed
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Chip ID',
                  border: OutlineInputBorder(),
                ),
                // Add validation logic if needed
              ),
              SizedBox(height: 20),
              // Add more form fields for male/female, family doctor, etc.
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitForm();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Fetch inventory names when the screen initializes
    _fetchInventoryNames();
  }

  // Method to fetch inventory names from Firestore
  Future<void> _fetchInventoryNames() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('inventory')
          .doc(getHospitalName())
          .collection('items')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _inventoryNames = querySnapshot.docs
              .map((doc) => doc['name'] as String)
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching inventory names: $e');
    }
  }

  // Method to detect input source (scanner or manual typing)
  // Method to detect input source (scanner or manual typing)
  void _detectInputSource() {
    final currentTime = DateTime.now();
    if (_lastInputTime != null &&
        currentTime.difference(_lastInputTime!) < Duration(milliseconds: 100)) {
      // If input events are very close together, assume it's from the scanner
      print('Input from scanner');
      // Fetch data from Firestore based on the scanned serial number
      _fetchInventoryDetailsBySerialNumber(_serialNumberController.text);
    } else {
      // Otherwise, treat it as manual typing
      print('Input from keyboard');
      _fetchInventoryDetailsBySerialNumber(_serialNumberController.text);
      // Select dropdown item corresponding to the typed serial number
      _selectDropdownItem(_serialNumberController.text);
    }
    _lastInputTime = currentTime;
  }

// Method to select dropdown item based on the serial number
  // Method to select dropdown item based on the serial number
  // Method to select dropdown item based on the serial number
  void _selectDropdownItem(String serialNumber) {
    setState(() {
      // Find the corresponding inventory name for the serial number
      String? foundName;
      for (String name in _inventoryNames) {
        if (name.contains(serialNumber)) {
          foundName = name;
          break;
        }
      }

      // If the selected inventory name is found, ensure it's unique
      if (foundName != null) {
        // Count occurrences of the selected name
        int count = _inventoryNames.where((name) => name == foundName).length;

        // If more than one occurrence, append a unique identifier
        if (count > 1) {
          _selectedInventoryName = '$foundName (${_inventoryNames.indexOf(foundName) + 1})';
        } else {
          _selectedInventoryName = foundName;
        }
      } else {
        _selectedInventoryName = null; // Reset to null if no matching name is found
      }
    });
  }




  // Method to fetch inventory details from Firestore based on serial number
  Future<void> _fetchInventoryDetailsBySerialNumber(String serialNumber) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('inventory')
          .doc(getHospitalName())
          .collection('items')
          .where('serialNumber', isEqualTo: serialNumber)
          .get();
      // Check if document exists
      if (querySnapshot.docs.isNotEmpty) {
        // Get data from first document
        Map<String, dynamic> data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        // Populate form fields with fetched data
        setState(() {
          _nameController.text = data['name'];
          // Populate other form fields similarly
        });
      } else {
        // Show error if document not found
      }
    } catch (e) {
      print('Error fetching inventory details: $e');
    }
  }

  // Method to fetch inventory details from Firestore based on name
  Future<void> _fetchInventoryDetailsByName(String name) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('inventory')
          .doc(getHospitalName())
          .collection('items')
          .where('name', isEqualTo: name)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data =
        querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          // Populate form fields with fetched data
          // For example:
          // _nameController.text = data['name'];
          // Populate other form fields similarly
        });
      }
    } catch (e) {
      print('Error fetching inventory details: $e');
    }
  }

  Widget _buildInventoryImage(String name) {
    // Replace this with your logic to load image based on inventory name
    // For demonstration, I'm using a placeholder AssetImage
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: AssetImage('assets/images/inventory_placeholder.png'), // Replace with actual image path
          fit: BoxFit.cover,
        ),
      ),
    );
  }



  // Method to submit the form
  void _submitForm() {
    // Implement form submission logic here
    // You can access form field values using controller.text
    // For example: _serialNumberController.text, _nameController.text, etc.
  }
}
