import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentinventory/Screens/InventoryFormScreen/add_inventory_screen_bloc.dart';
import 'package:rentinventory/Utils/shared_pref_utils.dart';
import 'package:rentinventory/base/src_widgets.dart';

import '../../base/basePage.dart';
import '../../base/bloc/base_bloc.dart';
import '../../widgets/common_alert_dialog.dart';
import '../../widgets/dynamic_table_library/dynamic_input_type/dynamic_table_image_input.dart';
import '../../widgets/dynamic_table_library/dynamic_input_type/dynamic_table_input_type.dart';
import '../../widgets/dynamic_table_library/dynamic_table_data_cell.dart';
import '../../widgets/dynamic_table_library/dynamic_table_data_column.dart';
import '../../widgets/dynamic_table_library/dynamic_table_data_row.dart';
import '../../widgets/dynamic_table_library/dynamic_table_widget.dart';
import 'form/form_screen.dart';

class AddInventoryScreen extends BasePage<AddInventoryScreenBloc> {
  const AddInventoryScreen({super.key});

  @override
  BasePageState<BasePage<BasePageBloc?>, BasePageBloc> getState() {
    return _AddInventoryScreenState();
  }

  static Route<dynamic> route(bool isSwitch, String mobileNumber) {
    return CustomPageRoute(builder: (context) => const AddInventoryScreen());
  }
}

class _AddInventoryScreenState extends BasePageState<AddInventoryScreen, AddInventoryScreenBloc> {
  AddInventoryScreenBloc bloc = AddInventoryScreenBloc();

  final _formKey = GlobalKey<FormState>();
  var tableKey = GlobalKey<DynamicTableState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Uint8List? _imageData;
  late bool _isSubmitting;
  String scannedCode = '';
  String scannedCode2 = '';

  @override
  void initState() {
    super.initState();
    bloc.getInventoryData(); // Call the method to get user data when the widget initializes
  }

  @override
  getBloc() {
    return bloc;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: bloc.inventoryStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
                child:
                    CircularProgressIndicator()), // Show loading indicator while data is loading
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
                child: Text(
                    'Error: ${snapshot.error}')), // Show error message if there's an error
          );
        }
        final documents = snapshot.data!.docs;
        return _buildScreenContent(documents);
      },
    );
  }

  Widget _buildScreenContent(List<DocumentSnapshot> documents) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDataTable(documents),
          ],
        ),
      ),
    );
  }

  Widget _buildFormWidget(String scannedCode) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildForm(scannedCode),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildPickImageBox(),
        ),
      ],
    );
  }

  Widget _buildForm(String code) {
    _serialNumberController.text = code;
    print(code);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 8),
        TextFormField(
          enabled: false,
          autofocus: true,
          controller: _serialNumberController,
          decoration: const InputDecoration(
            labelText: 'Serial Number',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the serial number';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the name';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget getDisplayImage() {
    return _imageData != null
        ? Center(
            child: Image.memory(
              _imageData!,
              fit: BoxFit.cover,
            ),
          )
        : SizedBox(); // Return an empty SizedBox if no image selected
  }

  Widget _buildPickImageBox() {
    return GestureDetector(
      onTap: () {
        _pickImage(); // Function to handle image picking
      },
      child: DottedBorder(
        color: Colors.black,
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        padding: const EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: _imageData != null
              ? Stack(
                  children: [
                    getDisplayImage(),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _removeImage(); // Function to remove selected image
                        },
                      ),
                    ),
                  ],
                )
              : Container(
                  height: 100,
                  color: Colors.black12,
                  child: const Center(
                    child: Text(
                      "Click here to add inventory image",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDataTable(List<DocumentSnapshot<Object?>> documents) {
    return Column(children: [
      SizedBox(
        width: double.infinity,
        child: DynamicTable(
          key: tableKey,
          header: const Text(
            "Inventory Table",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          onRowDelete: (index, row) {
            String documentId =
                documents[index].id; // Get the document ID using index
            _deleteInventoryItem(documentId);
            return true;
          },
          showActions: true,
          showAddRowButton: false,
          showDeleteAction: true,
          rowsPerPage: 10,
          showFirstLastButtons: true,
          availableRowsPerPage: const [
            10,
            20,
            30,
            40,
          ],
          dataRowMinHeight: 60,
          dataRowMaxHeight: 60,
          columnSpacing: 60,
          actionColumnTitle: "My Action Title",
          showCheckboxColumn: true,
          onSelectAll: (value) {},
          onRowsPerPageChanged: (value) {},
          actions: [
            ButtonView(
              "Add Inventory",
              () async {
                _showAddInventoryDialog();
              },
              postfix: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            Container(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
          rows: documents.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return DynamicTableDataRow(
              index: documents.indexOf(doc),
              cells: [
                DynamicTableDataCell(value: data['serialNumber']),
                DynamicTableDataCell(value: data['name']),
                // Display user email
                DynamicTableDataCell(
                    value: data['imageUrl'], showEditIcon: false),
              ],
              onSelectChanged: (value) {},
            );
          }).toList(),
          columns: [
            DynamicTableDataColumn(
                label: const Text("Scan Code"),
                dynamicTableInputType: DynamicTableInputType.text()),
            DynamicTableDataColumn(
                label: const Text("Name"),
                dynamicTableInputType: DynamicTableInputType.text()),
            DynamicTableDataColumn(
                isEditable: false,
                label: const Text("Image"),
                dynamicTableInputType: DynamicTableImageInput()),
          ],
        ),
      ),
    ]);
  }

  Future<void> _showAddInventoryDialog() async {
    final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return FormScreen();
        });
    if (result != null) {
      // getBloc().loadMessages();
    }
  }


  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageData = Uint8List.fromList(bytes);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _imageData = null;
    });
  }

  Future<void> _uploadImageAndAddInventoryToFirestore() async {
    try {
      setState(() {
        _isSubmitting = true; // Show progress bar
      });

      // Check if serial number already exists
      final querySnapshot = await FirebaseFirestore.instance
          .collection('inventory')
          .doc(getHospitalName())
          .collection('items')
          .where('serialNumber', isEqualTo: _serialNumberController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Serial number already exists
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inventory with this serial number already exists'),
          ),
        );
      } else {
        // Serial number doesn't exist, proceed with adding inventory item

        // Upload image data to Firestore
        String imageDataString = base64Encode(_imageData!);

        // Add inventory item to Firestore
        await FirebaseFirestore.instance
            .collection('inventory')
            .doc(getHospitalName())
            .collection('items')
            .add({
          'serialNumber': _serialNumberController.text,
          'name': _nameController.text,
          'imageUrl': imageDataString,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inventory added successfully'),
          ),
        );
      }
    } catch (e) {
      print('Error uploading image and adding inventory to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add inventory'),
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false; // Hide progress bar
      });
    }
  }
  Future<void> _deleteInventoryItem(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('inventory')
          .doc(getHospitalName())
          .collection('items')
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Inventory item deleted successfully'),
        ),
      );
    } catch (e) {
      print('Error deleting inventory item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete inventory item'),
        ),
      );
    }
  }
}
