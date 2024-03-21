import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()  //this is for hiding the previous snackbar if any exists
    ..showSnackBar(
      SnackBar(
        content: Text(content),
        behavior: SnackBarBehavior.floating,
      ),
    );
}
