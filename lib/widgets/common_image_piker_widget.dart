import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerBox extends StatefulWidget {
  final Function(Uint8List?) onImagePicked;

  const ImagePickerBox({super.key, required this.onImagePicked});

  @override
  _ImagePickerBoxState createState() => _ImagePickerBoxState();
}

class _ImagePickerBoxState extends State<ImagePickerBox> {
  Uint8List? _imageData;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageData = Uint8List.fromList(bytes);
      });
      widget.onImagePicked(_imageData);
    }
  }

  void _removeImage() {
    setState(() {
      _imageData = null;
    });
    widget.onImagePicked(null);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
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
                    Center(
                      child: Image.memory(
                        _imageData!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _removeImage,
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
}
