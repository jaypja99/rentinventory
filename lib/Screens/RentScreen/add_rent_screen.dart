import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rentinventory/Screens/InventoryFormScreen/InventoryItems.dart';
import 'package:rentinventory/Screens/RentScreen/add_rent_screen_bloc.dart';
import 'package:rentinventory/Utils/common_utils.dart';
import 'package:rentinventory/Utils/shared_pref_utils.dart';
import 'package:rentinventory/base/bloc/base_bloc.dart';

import '../../Utils/date_util.dart';
import '../../base/basePage.dart';
import '../../base/widgets/button_view.dart';
import '../../base/widgets/custom_page_route.dart';

class AddRentScreen extends BasePage<AddRentScreenBloc> {
  const AddRentScreen({Key? key}) : super(key: key);

  @override
  BasePageState<BasePage<BasePageBloc?>, BasePageBloc> getState() {
    return _AddRentScreenState();
  }

  static Route<dynamic> route(bool isSwitch, String mobileNumber) {
    return CustomPageRoute(builder: (context) => AddRentScreen());
  }
}

class _AddRentScreenState
    extends BasePageState<AddRentScreen, AddRentScreenBloc> {
  AddRentScreenBloc bloc = AddRentScreenBloc();

  final _formKey = GlobalKey<FormState>();
  TextEditingController _serialNumberController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  String? _selectedInventoryName;
  List<InventoryItem> _inventoryItems = [];

  DateTime? _lastInputTime; // Track the time of the last input
  TextEditingController _familyDoctorController = TextEditingController();
  String? _gender;
  DateTime? _givenDate;
  TimeOfDay? _givenTime;
  DateTime? _returnDate;
  TimeOfDay? _returnTime;

  TextEditingController _givenDateController = TextEditingController();
  TextEditingController _givenTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInventoryNames();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Serial Number Field
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _serialNumberController,
                    decoration: InputDecoration(
                      labelText: 'Serial Number',
                      border: OutlineInputBorder(),
                      suffixIcon: _serialNumberController.text.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _serialNumberController.clear();
                          setState(() {
                            _selectedInventoryName = null;
                          });
                        },
                      )
                          : null,
                    ),
                    onChanged: (value) {
                      _detectInputSource();
                    },
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedInventoryName,
                    items: _inventoryItems.map((item) =>
                        DropdownMenuItem<String>(
                          value: item.name,
                          child: Row(
                            children: [
                              _buildInventoryImage(item.imageUrl),
                              SizedBox(width: 8),
                              Text(item.name, style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        )
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedInventoryName = value;
                        _fetchInventoryDetailsByName(value!);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Inventory Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Patient Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Patient Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Gender Radio Buttons
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _familyDoctorController,
                    decoration: InputDecoration(
                      labelText: 'Family Doctor Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50], // Change color as needed
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gender', style: TextStyle(fontSize: 14)),
                      Row(
                        children: <Widget>[
                          Radio(
                            value: 'male',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value as String?;
                              });
                            },
                          ),
                          Text('Male'),
                          Radio(
                            value: 'female',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value as String?;
                              });
                            },
                          ),
                          Text('Female'),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),

            SizedBox(height: 20),

            // Given Date and Time Fields
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    onTap: () => _selectGivenDate(context),
                    controller: _givenDateController,
                    decoration: InputDecoration(
                      labelText: 'Given Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    onTap: () => _selectGivenTime(context),
                    controller: _givenTimeController,
                    decoration: InputDecoration(
                      labelText: 'Given Time',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.access_time),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ButtonView(
                  "Submit",
                      () async {
                    if (_formKey.currentState!.validate()) {
                      _submitForm();
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }



  @override
  AddRentScreenBloc getBloc() {
    return bloc;
  }

  Future<void> _fetchInventoryNames() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('inventory')
          .doc(getHospitalName())
          .collection('items')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _inventoryItems = querySnapshot.docs.map((doc) {
            // Assuming InventoryItem has a constructor that takes name and imageUrl
            return InventoryItem(
              name: doc['name'],
              imageUrl: doc['imageUrl'],
              serialNumber: doc['serialNumber'],
              // Add other fields as needed
            );
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching inventory names: $e');
    }
  }

  void _detectInputSource() {
    final currentTime = DateTime.now();
    if (_lastInputTime != null &&
        currentTime.difference(_lastInputTime!) < Duration(milliseconds: 100)) {
      print('Input from scanner');
      _selectDropdownItem(_serialNumberController.text);
    } else {
      print('Input from keyboard');
      _selectDropdownItem(_serialNumberController.text);
    }
    _lastInputTime = currentTime;
  }

  void _selectDropdownItem(String serialNumber) {
    setState(() {
      // Find the corresponding inventory item for the serial number
      InventoryItem? foundItem;
      for (InventoryItem item in _inventoryItems) {
        if (item.serialNumber.contains(serialNumber)) {
          foundItem = item;
          break;
        }
      }

      // If the selected inventory item is found, ensure its name is unique
      if (foundItem != null) {
        // Count occurrences of the selected name
        int count = _inventoryItems
            .where((item) => item.name == foundItem!.name)
            .length;

        // If more than one occurrence, append a unique identifier
        if (count > 1) {
          _selectedInventoryName =
              '${foundItem!.name} (${_inventoryItems.indexOf(foundItem) + 1})';
        } else {
          _selectedInventoryName = foundItem!.name;
        }
      } else {
        _selectedInventoryName =
            null; // Reset to null if no matching item is found
      }
    });
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
        setState(() {});
      }
    } catch (e) {
      print('Error fetching inventory details: $e');
    }
  }

  Widget _buildInventoryImage(String name) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: MemoryImage(base64Decode(name)),
          // Replace with actual image path
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _selectGivenDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _givenDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _givenDate) {
      setState(() {
        _givenDate = picked;
        // Update the text form field's initial value
        _givenDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _selectGivenTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _givenTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _givenTime) {
      setState(() {
        _givenTime = picked;
        // Update the text form field's initial value
        _givenTimeController.text = picked.format(context);
      });
    }
  }

  // Method to submit the form
  void _submitForm() {}
}
