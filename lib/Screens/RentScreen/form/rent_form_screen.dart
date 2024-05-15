import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentinventory/Screens/RentScreen/form/rent_form_screen_bloc.dart';
import 'package:rentinventory/base/components/screen_utils/flutter_screenutil.dart';
import 'package:rentinventory/base/constants/app_widgets.dart';
import 'package:rentinventory/base/src_widgets.dart';
import 'package:rentinventory/widgets/common_barcode_scanner_dialog/common_barcode_scanner.dart';

import '../../../Utils/shared_pref_utils.dart';
import '../../../base/basePage.dart';
import '../../../widgets/common_form_dialog/common_form_screen.dart';
import '../../../widgets/common_image_piker_widget.dart';

class InventoryFromScreen extends BasePage<RentFormScreenBloc> {
  const InventoryFromScreen({super.key});

  @override
  BasePageState<InventoryFromScreen, RentFormScreenBloc> getState() {
    return _FormScreenState();
  }
}

class _FormScreenState
    extends BasePageState<InventoryFromScreen, RentFormScreenBloc> {
  final RentFormScreenBloc _bloc = RentFormScreenBloc();
  final FocusNode _focusNode = FocusNode();
  final barcodeScanner = BarcodeScanner();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  var serialNumber = "";

  Uint8List? _imageData;
  final bool _isSubmitting = false;
  bool _scanNumberEnabled = false;

  @override
  bool isRemoveScaffold() => true;

  @override
  RentFormScreenBloc getBloc() {
    return _bloc;
  }

  @override
  Widget? getAppBar() {
    return null;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return _isSubmitting
        ? const ProgressView()
        : CommonFormScreen(
            formTitleText: "Add Inventory",
            formButtonText: "Submit",
            contentWidget: buildContentView(),
            onCloseTapped: () {},
            onButtonTapped: () {
              _bloc.AddInventory(
                  _serialNumberController,
                  _nameController,
                  _imageData,
                  context);
            },
          );
  }

  Widget buildContentView() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      padding: EdgeInsets.all(15.w),
      child: Column(
        children: [
          _buildFormWidget()
        ],
      ),
    );
  }

  Widget _buildFormWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildForm(),
        ),
        ImagePickerBox(
          onImagePicked: (imageData) {
            setState(() {
              _imageData = imageData;
            });
          },
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                autofocus: true,
                enabled: _scanNumberEnabled,
                // Set the enabled state based on the flag
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonView("Scan Number",
                  postfix: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                  ), () async {
                setState(() {
                  _scanNumberEnabled = false; // Enable scan number field
                });
                serialNumber = "";
                final result =
                    await barcodeScanner.showBarcodeScannerDialog(context);
                if (result != null) {
                  _serialNumberController.text = result;
                }
              }),
            ),
            ButtonView("Enter Manually", () {
              setState(() {
                _scanNumberEnabled = true; // Enable scan number field
              });
            }),
          ],
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
        : const SizedBox(); // Return an empty SizedBox if no image selected
  }
}
