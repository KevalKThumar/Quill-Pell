import 'package:flutter/material.dart';

import '../../theme/app_pallete.dart';

Future<dynamic> dialogBox(
      {required BuildContext context,
      required VoidCallback onNoPressed,
      required VoidCallback onYesPressed,
      required String title}) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: AppPallete.backgroundColor,
          content: Text(
            title,
            style: const TextStyle(
              color: AppPallete.whiteColor,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: onNoPressed,
              child: const Text(
                'No',
                style: TextStyle(
                  color: AppPallete.gradient3,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
            TextButton(
              onPressed: onYesPressed,
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: AppPallete.gradient3,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

