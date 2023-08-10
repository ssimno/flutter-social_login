import 'package:flutter/material.dart';

class CommonUtilities {
  static void showMessageBox({
    required BuildContext context,
    String? title,
    required String content,
    String? cancelStr,
    String? okStr,
    Color okColor = Colors.blue,
    VoidCallback? cancelBtn,
    VoidCallback? okBtn,
    Color cancelColor = Colors.blue,
  }) {
    showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            title: title != null ? Text(title) : null,
            content: Text(content),
            actions: [
              if (cancelBtn != null)
                TextButton(
                  onPressed: () {
                    cancelBtn();
                    Navigator.pop(context);
                  },
                  child: Text(
                    cancelStr ?? "",
                    style: TextStyle(
                      color: cancelColor,
                    ),
                  ),
                ),
              if (okBtn != null)
                TextButton(
                  onPressed: () {
                    okBtn();
                    Navigator.pop(context);
                  },
                  child: Text(
                    okStr ?? "",
                    style: TextStyle(
                      color: okColor,
                    ),
                  ),
                ),
            ],
          );
        });
  }
}
