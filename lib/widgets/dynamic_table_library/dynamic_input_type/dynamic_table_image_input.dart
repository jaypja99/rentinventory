import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'dynamic_table_input_type.dart';

class DynamicTableImageInput extends DynamicTableInputType<String> {
  final ImageProvider? imageProvider;
  final double imageSize;

  DynamicTableImageInput({
    this.imageProvider,
    this.imageSize = 60.0,
  });

  @override
  Widget displayWidget(String? value) {
    // Check if value is not null and not empty
    if (value != null && value.isNotEmpty) {
      Uint8List imageDataBytes = base64Decode(value);

      return Padding(
        padding: const EdgeInsets.all(5),
        child: Image.memory(
          imageDataBytes,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.cover,
        ),
      );
    } else {
      // If value is null or empty, display a placeholder
      return Container(
        width: imageSize,
        height: imageSize,
        color: Colors.grey,
        child: Icon(
          Icons.image_not_supported,
          color: Colors.white,
        ),
      );
    }
  }

  @override
  Widget editingWidget(
      String? value,
      Function(String? value, int row, int column)? onChanged,
      int row,
      int column,
      ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onChanged: (value) {
          onChanged?.call(value, row, column);
        },
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          floatingLabelBehavior: FloatingLabelBehavior.never,

          border: OutlineInputBorder(),
          labelText: "Enter a value",
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose any resources if needed
  }
}
