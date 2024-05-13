import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays Material dialog above the current contents of the app

class CommonAlertDialog extends StatelessWidget {
  const CommonAlertDialog({
    super.key,
    this.title,
    this.customView = const SizedBox(),
    this.onCancelClick,
    this.onSubmitClick,
  });

  /// [customView] a widget to display a custom widget instead of the animation view.
  final Widget customView;

  /// [title] your dialog title
  final String? title;
  final Function()? onCancelClick;
  final Function()? onSubmitClick;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(25),
      title: Text(
        title ?? "",
        style: GoogleFonts.raleway(),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5, child: customView),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onCancelClick,
          child: Text('Close'),
        ),
        TextButton(onPressed: onSubmitClick, child: Text("Submit"))
      ],
    );
  }
}
