import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoading(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 5,
                ),
                Text(message!)
              ],
            ),
          );
        });
  }

  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage(BuildContext context, String message,
      {String? title,
      String? positiveActionName,
      VoidCallback? positiveAction,
      String? negativeActionName,
      VoidCallback? negativeAction,
      bool barrierDismissible = true}) {
    List<Widget> actions = [];

    if (positiveActionName != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            positiveAction?.call();
          },
          child: Text(positiveActionName)));
    }
    if (negativeActionName != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            negativeAction?.call();
          },
          child: Text(negativeActionName)));
    }
    showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
            title: Text(title ?? 'title'),
            actions: actions,
          );
        });
  }
}
