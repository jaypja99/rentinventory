import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentinventory/Screens/AddHospitalScreen/add_hospital_screen_bloc.dart';
import 'package:rentinventory/base/src_constants.dart';
import 'package:rentinventory/base/src_widgets.dart';

import '../../base/basePage.dart';
import '../../base/bloc/base_bloc.dart';
import '../../base/constants/app_widgets.dart';
import '../../base/widgets/custom_page_route.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/dynamic_table_library/dynamic_input_type/dynamic_table_input_type.dart';
import '../../widgets/dynamic_table_library/dynamic_table_data_cell.dart';
import '../../widgets/dynamic_table_library/dynamic_table_data_column.dart';
import '../../widgets/dynamic_table_library/dynamic_table_data_row.dart';
import '../../widgets/dynamic_table_library/dynamic_table_widget.dart';

class AddHospitalScreen extends BasePage<AddHospitalScreenBloc> {
  AddHospitalScreen({Key? key}) : super(key: key);

  @override
  BasePageState<BasePage<BasePageBloc?>, BasePageBloc> getState() {
    return _AddHospitalScreenState();
  }

  static Route<dynamic> route(bool isSwitch, String mobileNumber) {
    return CustomPageRoute(builder: (context) => AddHospitalScreen());
  }
}

class _AddHospitalScreenState
    extends BasePageState<AddHospitalScreen, AddHospitalScreenBloc> {
  AddHospitalScreenBloc bloc = AddHospitalScreenBloc();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _hospitalNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  List<DocumentSnapshot> selectedDocuments = [];


  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String _selectedRole = 'admin'; // Default role is admin
  bool _isHospitalRole = false; // Whether the selected role is hospital or not

  @override
  void initState() {
    super.initState();
    bloc.getHospitalData(); // Call the method to get user data when the widget initializes
  }

  void togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      _confirmPasswordVisible = !_confirmPasswordVisible;
    });
  }

  @override
  getBloc() {
    return bloc;
  }

  @override
  Widget buildWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8),
                Row(
                  children: [
                    Radio(
                      value: 'admin',
                      groupValue: _selectedRole,
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value.toString();
                          _isHospitalRole = false;
                        });
                      },
                    ),
                    Text('Admin'),
                    SizedBox(width: 20),
                    Radio(
                      value: 'hospital',
                      groupValue: _selectedRole,
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value.toString();
                          _isHospitalRole = true;
                        });
                      },
                    ),
                    Text('Hospital'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _userNameController,
                        decoration: InputDecoration(
                          labelText: 'Enter User Name',
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the user name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _userEmailController, // Assign the controller for user email
                        decoration: InputDecoration(
                          labelText: 'Enter Email', // Change label to 'Enter Email'
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress, // Set keyboard type to email address
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the email'; // Change validation message
                          }
                          if (!isValidEmail(value)) { // Add email validation
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Enter Password',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: togglePasswordVisibility,
                          ),
                        ),
                        obscureText: !_passwordVisible,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the password';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: toggleConfirmPasswordVisibility,
                          ),
                        ),
                        obscureText: !_confirmPasswordVisible,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the confirm password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                if (_isHospitalRole) ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _hospitalNameController,
                          decoration: InputDecoration(
                            labelText: 'Enter Hospital Name',
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the hospital name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Enter Address',
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the address';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  child: ButtonView("Submit", () {
                    if (_formKey.currentState!.validate()) {
                      final String name = _userNameController.text;
                      final String email = _userEmailController.text; // Get user email
                      final String password = _passwordController.text;
                      final String role = _selectedRole;
                      final String? hospitalName = _isHospitalRole ? _hospitalNameController.text : null;
                      final String? address = _isHospitalRole ? _addressController.text : null;
                      bloc.addUserData(name, email, password, role, hospitalName, address); // Pass email to bloc method
                      clearData();
                    }
                  }),
                ),
                SizedBox(height: 20),
                buildTable()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTable() {
    return StreamBuilder<QuerySnapshot>(
      stream: bloc.hospitalStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final documents = snapshot.data!.docs;
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: DynamicTable(
                header: const Text("User Table"),
                rowsPerPage: 5,
                showFirstLastButtons: true,
                availableRowsPerPage: const [5, 10, 15, 20],
                columnSpacing: 60,
                showDeleteAction: true,
                showCheckboxColumn: true,
                onRowsPerPageChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    showMessageBar("Rows Per Page Changed to $value"),
                  );
                },
                onRowDelete: (index, row) {
                  final data = documents[index].data() as Map<String, dynamic>;
                  final role = data['role'];
                  if (role == 'admin') {
                    showMessageBar("You can't delete admin users.");
                    return false;
                  } else {
                    bloc.deleteUser(documents[index]);
                    return true;
                  }
                },
                actions: [
                  ButtonView("Delete Selected", () { final isAdminSelected = selectedDocuments.any((doc) =>
                  (doc.data() as Map<String, dynamic>)['role'] == 'admin');
                  if (isAdminSelected) {
                    showMessageBar("You can't delete admin users.");
                  } else {
                    selectedDocuments.isNotEmpty
                        ? bloc.deleteSelectedUsers(selectedDocuments)
                        : () {
                      showMessageBar("First select any user to delete");
                    };
                  } })
                ],
                rows: documents.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final role = data['role'];
                  return DynamicTableDataRow(
                    index: documents.indexOf(doc),
                    cells: [
                      DynamicTableDataCell(value: data['name']),
                      DynamicTableDataCell(value: data['loginAccessEmail']), // Display user email
                      DynamicTableDataCell(value: data['role']),
                      DynamicTableDataCell(value: data['hospitalName']),
                      DynamicTableDataCell(value: data['address']),
                      DynamicTableDataCell(value: data['createdAt']),
                    ],
                    onSelectChanged: (value) {
                      final role = data['role'];
                      if (role == 'admin') {
                        showMessageBar("You can't select admin users.");
                      } else {
                        if (value ?? false) {
                          selectedDocuments.add(doc); // Add selected user to the list
                        } else {
                          selectedDocuments.remove(
                              doc); // Remove deselected user from the list
                        }
                      }
                    },
                  );
                }).toList(),
                columns: [
                  DynamicTableDataColumn(
                    label: const Text("User Name"),
                    onSort: (columnIndex, ascending) {},
                    dynamicTableInputType: DynamicTableTextInput(),
                  ),
                  DynamicTableDataColumn(
                    label: const Text("User Email"),
                    onSort: (columnIndex, ascending) {},
                    dynamicTableInputType: DynamicTableTextInput(),
                  ),
                  DynamicTableDataColumn(
                    label: const Text("Role"),
                    onSort: (columnIndex, ascending) {},
                    dynamicTableInputType: DynamicTableTextInput(),
                  ),
                  DynamicTableDataColumn(
                    label: const Text("Hospital Name"),
                    onSort: (columnIndex, ascending) {},
                    dynamicTableInputType: DynamicTableTextInput(),
                  ),
                  DynamicTableDataColumn(
                    label: const Text("Address"),
                    onSort: (columnIndex, ascending) {},
                    dynamicTableInputType: DynamicTableTextInput(),
                  ),
                  DynamicTableDataColumn(
                    label: const Text("Created At"),
                    onSort: (columnIndex, ascending) {},
                    dynamicTableInputType: DynamicTableTextInput()
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void clearData(){
    _userNameController.clear();
    _userEmailController.clear(); // Clear email controller
    _passwordController.clear();
    _confirmPasswordController.clear();
    _hospitalNameController.clear();
    _addressController.clear();
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }


}
