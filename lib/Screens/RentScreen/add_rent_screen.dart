import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentinventory/Screens/RentScreen/add_rent_screen_bloc.dart';
import 'package:rentinventory/base/bloc/base_bloc.dart';

import '../../base/basePage.dart';
import '../../base/widgets/button_view.dart';
import '../../base/widgets/custom_page_route.dart';
import '../../widgets/dynamic_table_library/dynamic_input_type/dynamic_table_input_type.dart';
import '../../widgets/dynamic_table_library/dynamic_table_data_cell.dart';
import '../../widgets/dynamic_table_library/dynamic_table_data_column.dart';
import '../../widgets/dynamic_table_library/dynamic_table_data_row.dart';
import '../../widgets/dynamic_table_library/dynamic_table_widget.dart';
import 'form/rent_form_screen.dart';

class AddRentScreen extends BasePage<AddRentScreenBloc> {
  const AddRentScreen({super.key});

  @override
  BasePageState<BasePage<BasePageBloc?>, BasePageBloc> getState() {
    return _AddRentScreenState();
  }

  static Route<dynamic> route(bool isSwitch, String mobileNumber) {
    return CustomPageRoute(builder: (context) => const AddRentScreen());
  }
}

class _AddRentScreenState
    extends BasePageState<AddRentScreen, AddRentScreenBloc> {
  AddRentScreenBloc bloc = AddRentScreenBloc();
  var tableKey = GlobalKey<DynamicTableState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc.getInventoryData(); // Call the method to get user data when the widget initializes
  }

  @override
  AddRentScreenBloc getBloc() {
    return bloc;
  }

  @override
  Widget buildWidget(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: bloc.rentStream,
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
            _buildRentTable(documents),
          ],
        ),
      ),
    );
  }

  Widget _buildRentTable(List<DocumentSnapshot<Object?>> documents) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: DynamicTable(
            key: tableKey,
            header: const Text(
              "Rent Table",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            onRowDelete: (index, row) {
              String documentId = documents[index].id;
              // _deleteRentItem(documentId);
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
            columnSpacing: 5,
            actionColumnTitle: "Action",
            showCheckboxColumn: true,
            onSelectAll: (value) {},
            onRowsPerPageChanged: (value) {},
            actions: [
              ButtonView(
                color: Colors.redAccent,
                "Delete Selected",
                () async {},
                postfix: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              ButtonView(
                "Add Inventory",
                () async {
                  _showAddRentDialog();
                },
                postfix: const Icon(
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
                  _buildTableCell(data['serialNumber']),
                  _buildTableCell(data['name']),
                  _buildTableCell(data['familyDoctor']),
                  _buildTableCell(data['gender']),
                  _buildTableCell(data['given_time']),
                  _buildTableCell(data['given_date']),
                  _buildTableCell(data['return_date']),
                  _buildTableCell(data['return_time']),
                ],
                onSelectChanged: (value) {},
              );
            }).toList(),
            columns: [
              DynamicTableDataColumn(
                label: const Text("Serial Number"),
                dynamicTableInputType: DynamicTableInputType.text(),
              ),
              DynamicTableDataColumn(
                label: const Text("Patient Name"),
                dynamicTableInputType: DynamicTableInputType.text(),
              ),
              DynamicTableDataColumn(
                label: const Text("Family Doctor"),
                dynamicTableInputType: DynamicTableInputType.text(),
              ),
              DynamicTableDataColumn(
                label: const Text("Gender"),
                dynamicTableInputType: DynamicTableInputType.text(),
              ),
              DynamicTableDataColumn(
                label: const Text("Given Time"),
                dynamicTableInputType: DynamicTableInputType.text(),
              ),
              DynamicTableDataColumn(
                label: const Text("Given Date"),
                dynamicTableInputType: DynamicTableInputType.text(),
              ),
              DynamicTableDataColumn(
                label: const Text("Return Date"),
                dynamicTableInputType: DynamicTableInputType.text(),
              ),
              DynamicTableDataColumn(
                label: const Text("Return Time"),
                dynamicTableInputType: DynamicTableInputType.text(),
              ),

              // Add more columns for other rent fields
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showAddRentDialog() async {
    final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const RentFormScreen();
        });
    if (result != null) {
      bloc.getInventoryData();
    }
  }

  DynamicTableDataCell _buildTableCell(dynamic value) {
    // Check if value is null or empty, then return a placeholder
    if (value == null || value.toString().isEmpty) {
      return DynamicTableDataCell(value: "-");
    } else {
      return DynamicTableDataCell(value: value);
    }
    // Otherwise, return the cell value
  }
}
