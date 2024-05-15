import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class BarcodeScanner {
  final FocusNode _focusNode = FocusNode();
  String serialNumber = '';

  Future<String?> showBarcodeScannerDialog(BuildContext context) async {
    final result = await showDialog<String>(
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
              const SizedBox(height: 20),
              KeyboardListener(
                autofocus: true,
                focusNode: _focusNode,
                onKeyEvent: (event) {
                  if (event is KeyDownEvent) {
                    // Check if it's a key down event
                    serialNumber += event.logicalKey.keyLabel;
                    if (serialNumber.length == 8) {
                      Navigator.pop(context, serialNumber);
                    }
                  }
                },
                child: const Text("Please Scan your barcode"),
              ),
            ],
          ),
        );
      },
    );
    serialNumber = ''; // Reset serial number for next use
    return result;
  }
}
