import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentinventory/Screens/InventoryFormScreen/add_inventory_screen_bloc.dart';
import 'package:rentinventory/Screens/InventoryFormScreen/form/inventory_form_screen.dart';
import 'package:rentinventory/base/constants/app_constant.dart';
import 'package:rentinventory/base/constants/app_widgets.dart';
import 'package:rentinventory/base/src_widgets.dart';

import '../../base/basePage.dart';
import '../../base/bloc/base_bloc.dart';
import '../../widgets/dynamic_table_library/dynamic_input_type/dynamic_table_image_input.dart';
import '../../widgets/dynamic_table_library/dynamic_input_type/dynamic_table_input_type.dart';
import '../../widgets/dynamic_table_library/dynamic_table_data_cell.dart';
import '../../widgets/dynamic_table_library/dynamic_table_data_column.dart';
import '../../widgets/dynamic_table_library/dynamic_table_data_row.dart';
import '../../widgets/dynamic_table_library/dynamic_table_widget.dart';

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

class _AddInventoryScreenState
    extends BasePageState<AddInventoryScreen, AddInventoryScreenBloc> {
  AddInventoryScreenBloc bloc = AddInventoryScreenBloc();

  var tableKey = GlobalKey<DynamicTableState>();
  final TextEditingController _searchController = TextEditingController();
  List<String> selectedDocumentIds = [];

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
            bloc.deleteInventoryItem(documentId);
            return true;
          },
          onRowEdit: (index, row) {
            return true;
          },
          onRowSave: (index, oldValue, newValue) {
            String documentId = documents[index].id;
            final Map<String, dynamic> newValueMap = {
              'serialNumber': newValue[0],
              'name': newValue[1],
            };
            bloc.updateInventoryItem(documentId, newValueMap);
            return newValue; // Return the new values
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
          actions: [
            ButtonView(
              color: Colors.redAccent,
              "Delete Selected",
              () async {
                await bloc.deleteSelectedInventoryItems(selectedDocumentIds);
                bloc.getInventoryData();
              },
              postfix: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
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
                DynamicTableDataCell(value: data['imageUrl']),
              ],
              onSelectChanged: (value) {
                if (value == true) {
                  selectedDocumentIds.add(documents[ documents.indexOf(doc)].id);
                } else {
                  selectedDocumentIds.remove(documents[ documents.indexOf(doc)].id);
                }
              },
            );
          }).toList(),
          columns: [
            DynamicTableDataColumn(
                isEditable: false,
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
          return const InventoryFromScreen();
        });
    if (result != null) {
      bloc.getInventoryData();
    }
  }

  Future<void> _deleteInventoryItem(String documentId) async {
    try {} catch (e) {
      print('Error deleting inventory item: $e');
    }
  }
}
