import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentinventory/base/components/screen_utils/flutter_screenutil.dart';

import '../../../base/basePage.dart';
import '../../../widgets/common_form_dialog/common_form_screen.dart';
import 'form_screen_bloc.dart';

class FormScreen extends BasePage<FormScreenBloc> {
  const FormScreen({Key? key}) : super(key: key);

  @override
  BasePageState<FormScreen, FormScreenBloc> getState() {
    return _FormScreenState();
  }
}

class _FormScreenState extends BasePageState<FormScreen, FormScreenBloc> {

  final FormScreenBloc _bloc = FormScreenBloc();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Uint8List? _imageData;
  late bool _isSubmitting;


  @override
  void initState() {
    super.initState();
  }

  @override
  bool isRemoveScaffold() => true;

  @override
  FormScreenBloc getBloc() {
    return _bloc;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget? getAppBar() {
    return null;
  }

  @override
  Widget buildWidget(BuildContext context) {
    return CommonFilterScreen(
      filterTitleText: "Add Inventory",
      filterButtonText: "Submit",
      contentWidget: buildContentView(),
      onCloseTapped: () {},
      onButtonTapped: () {},
    );
  }

  Widget buildContentView() {
    return Container(
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildPickImageBox(),
        ),
      ],
    );
  }

  Widget _buildForm( ) {
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
}
