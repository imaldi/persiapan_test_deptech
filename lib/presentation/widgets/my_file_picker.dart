import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/consts/numbers.dart';
import 'my_confirm_dialog.dart';
import 'my_toast.dart';

class MyFilePickerWidget extends StatefulWidget {
  MyFilePickerWidget(
      this.setFileField, {
        Key? key,
        this.isEnabled = true,
        this.fileURL,
        // this.checkIsEmpty = _checkIsEmptyDefault
      }) : super(key: key);

  // File? issuerImage;
  Function(File? theFile) setFileField;
  // bool Function() checkIsEmpty;
  bool isEnabled;
  String? fileURL;

  @override
  _MyFilePickerWidgetState createState() => _MyFilePickerWidgetState();
}

class _MyFilePickerWidgetState extends State<MyFilePickerWidget> {
  File? _storedFile;

  Future _pickFile() async {
    // File file = await FilePicker?.getFile();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      _storedFile = File(result.files.single.path ?? "empty");
      widget.setFileField(_storedFile);
      print("_storedImage path : ${_storedFile?.path}");
    } else {
      myToast("Canceled");
      // User canceled the picker
    }

    //multiple
    // FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    //
    //
  }

  Future _showDialogPickImageFromGalleryOrCamera() async {
    return myConfirmDialog(context,
        basicContentString: "Choose Report File",
        positiveButton: () async {
          await _pickFile();
          setState(() {
            print("setState when picfile called");
            widget.fileURL = null;
          });
        },
        positiveButtonText: "Choose",
        negativeButton: () async {
          Navigator.of(context).pop();
        },
        negativeButtonText: "Cancel");
  }

  // @override
  // void initState() {
  //   if (!widget.checkIsEmpty()) {
  //     widget.fileURL == null;
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isEnabled
          ? () {
        _showDialogPickImageFromGalleryOrCamera();
        // _pickFile();
      }
          : null,
      child: SizedBox(
        height: sizeHuge * 5,
        // height: widthScreen(context) / 3,
        width: sizeHuge * 5,
        // width: widthScreen(context) / 3,
        child: Container(
            height: null,
            width: null,
            child: widget.fileURL == null
                ? _storedFile == null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Icon(
                    Icons.attach_file,
                    size: sizeHuge * 2,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                    child: Text(
                      "No file selected",
                      textAlign: TextAlign.center,
                    ))
              ],
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.file_download_done,
                  size: sizeHuge * 3,
                  color: Colors.grey,
                ),
                Text(
                  "${_storedFile?.path.split("/").last}",
                  overflow: TextOverflow.ellipsis,
                )
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.file_copy,
                  size: sizeHuge * 3,
                  color: Colors.grey,
                ),
                Text("${widget.fileURL?.split("/").last}")
              ],
            )),
      ),
    );
  }
}
