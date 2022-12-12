import 'package:flutter/material.dart';

import '../../core/consts/numbers.dart';
import '../../core/helper/screen_size.dart';

Future myConfirmDialog(
  BuildContext context, {
  String? basicContentString,
  String? title,
  String? positiveButtonText,
  String? negativeButtonText,
  Function? positiveButton,
  Function? negativeButton,
  Widget? customContent,
}) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? "Confirm",
          ),
        ],
      ),
      content: customContent ??
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                basicContentString ?? ""
                // "$content",
                // style: sansPro(fontWeight: FontWeight.w600, fontSize: 16),
                ,
                softWrap: true,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
      actions: [
        Container(
          margin: const EdgeInsets.all(sizeNormal),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Container(
                  height: 45,
                  width: widthScreen(context),
                  child: ElevatedButton(
                    onPressed: () {
                      if (negativeButton != null) {
                        negativeButton();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sizeNormal)),
                      backgroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                    ),
                    child: Text(negativeButtonText ?? "No"),
                  ),
                ),
              ),
              const SizedBox(width: sizeMedium),
              Flexible(
                child: Container(
                  height: 45,
                  width: widthScreen(context),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sizeNormal)),
                      backgroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                    ),
                    onPressed: () {
                      positiveButton!();
                      // Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text(positiveButtonText ?? "Yes"),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
