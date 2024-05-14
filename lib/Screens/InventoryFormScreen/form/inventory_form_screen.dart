import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:rentinventory/base/components/screen_utils/flutter_screenutil.dart';
import 'package:rentinventory/base/src_widgets.dart';

import '../../../Utils/shared_pref_utils.dart';
import '../../../base/basePage.dart';
import '../../../widgets/common_form_dialog/common_form_screen.dart';
import 'inventory_form_screen_bloc.dart';

class InventoryFromScreen extends BasePage<InventroyFormScreenBloc> {
  const InventoryFromScreen({super.key});

  @override
  BasePageState<InventoryFromScreen, InventroyFormScreenBloc> getState() {
    return _FormScreenState();
  }
}

class _FormScreenState
    extends BasePageState<InventoryFromScreen, InventroyFormScreenBloc> {
  final InventroyFormScreenBloc _bloc = InventroyFormScreenBloc();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();

  Uint8List? _imageData;
  final FocusNode _focusNode = FocusNode();
  bool _isSubmitting = false;
  var serialNumber = "";
  bool _scanNumberEnabled =
      false; // Flag to manage the enabled state of the scan number field

  @override
  bool isRemoveScaffold() => true;

  @override
  InventroyFormScreenBloc getBloc() {
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
    return _isSubmitting ? ProgressView() : CommonFormScreen(
      formTitleText: "Add Inventory",
      formButtonText: "Submit",
      contentWidget: buildContentView(),
      onCloseTapped: () {},
      onButtonTapped: () {
        _uploadImageAndAddInventoryToFirestore();
      },
    );
  }

  Widget buildContentView() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      padding: EdgeInsets.all(15.w),
      child: Column(
        children: [_buildFormWidget()],
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildPickImageBox(),
        ),
      ],
    );
  }

  @override
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
                final result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset("assets/images/LottieLogo1.json"),
                          const SizedBox(
                            height: 20,
                          ),
                          KeyboardListener(
                            autofocus: true,
                            focusNode: _focusNode,
                            onKeyEvent: (event) {
                              if (event is KeyDownEvent) {
                                // Check if it's a key down event
                                serialNumber = serialNumber +
                                    event.logicalKey.keyLabel.characters
                                        .toString();
                                if (serialNumber.toString().length == 8) {
                                  Navigator.pop(context, serialNumber);
                                }
                              }
                            },
                            child: const Text("Please Scan your barcode"),
                          )
                        ],
                      ),
                    );
                  },
                );
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

  Widget _buildPickImageBox() {
    return GestureDetector(
      onTap: () {
        _pickImage(); // Function to handle image picking
      },
      child: DottedBorder(
        color: Colors.black,
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inventory with this serial number already exists'),
          ),
        );
      } else {
        String imageDataString = base64Encode(_imageData!);

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
          const SnackBar(
            content: Text('Inventory added successfully'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add inventory'),
        ),
      );
    } finally {
      Navigator.of(context).pop();
      setState(() {
        _isSubmitting = false; // Hide progress bar
      });
    }
  }
}
