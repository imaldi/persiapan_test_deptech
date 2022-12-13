import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persiapan_test_deptech/presentation/widgets/my_image_picker/widget_cubit/ImagePickerCubit.dart';

import '../../../core/consts/numbers.dart';
import '../my_confirm_dialog.dart';

class MyImagePickerWidget extends StatefulWidget {
  MyImagePickerWidget(
    this.setImageFile, {
    Key? key,
    this.isEnabled = true,
    this.imageURL,
    this.title,
    this.localImageURL,
        this.customDefaultIcon,
    // this.checkIsEmpty = _checkIsEmptyDefault
  }) : super(key: key);

  // File? issuerImage;
  Function(File? theImage) setImageFile;

  // bool Function() checkIsEmpty;
  bool isEnabled;
  String? imageURL;
  String? localImageURL;
  String? title;
  Icon? customDefaultIcon;

  @override
  _MyImagePickerWidgetState createState() => _MyImagePickerWidgetState();
}

class _MyImagePickerWidgetState extends State<MyImagePickerWidget> {
  File? _storedImage;

  // File ;
  Future _takePicture(BuildContext context, ImagePickerCubitState state) async {
    ImagePicker imagePicker = ImagePicker();
    var cubit = context.read<ImagePickerCubit>();

    PickedFile? pickedFile =
        await imagePicker.getImage(source: ImageSource.camera).whenComplete(() {
      // setState(() {});
      Navigator.of(context).pop();
    });
    print("pickedFile path : ${pickedFile?.path}");

    _storedImage = File(pickedFile?.path ?? "");
    cubit.updateState(storedImage: _storedImage);
    widget.setImageFile(_storedImage);
    FocusScope.of(context).unfocus();

    // print("_storedImage path : ${_storedImage?.path}");

    // widget.issuerImage = _storedImage;
    // ImagePicker imagePicker = ImagePicker();
    // final imageFile = await imagePicker.getImage(source: ImageSource.camera,
    //   maxWidth: 600,
    // );
    // if (imageFile == null) {
    //   return;
    // }
    // setState(() {
    //   _storedImage = imageFile;
    // });
    // final appDir = await syspaths.getApplicationDocumentsDirectory();    final fileName = path.basename(imageFile.path);
    // final savedImage = await imageFile.copy('${appDir.path}/$fileName');
  }

  Future _pickFile(BuildContext context, ImagePickerCubitState state) async {
    var cubit = context.read<ImagePickerCubit>();

    // FilePickerResult? result = await FilePicker.platform.pickFiles();

    // if(result != null) {
    // _storedImage = File(result.files.single.path ?? "");
    ImagePicker imagePicker = ImagePicker();

    PickedFile? pickedFile = await imagePicker
        .getImage(source: ImageSource.gallery)
        .whenComplete(() {
      // setState(() {});
    });

    print("pickedFile path : ${pickedFile?.path}");

    _storedImage = File(pickedFile?.path ?? "");
    // widget.issuerImage = _storedImage;
    cubit.updateState(storedImage: _storedImage);

    widget.setImageFile(_storedImage);

    print("_storedImage path : ${_storedImage?.path}");
    FocusScope.of(context).unfocus();

    // print("issuerImage from detail page path : ${widget.issuerImage?.path}");
    // } else {
    //   // User canceled the picker
    // }
  }

  Future _showDialogPickImageFromGalleryOrCamera(
      BuildContext context, ImagePickerCubitState state) async {
    return myConfirmDialog(context,
        basicContentString: "Choose Report Image",
        positiveButton: () async {
          await _pickFile(context, state);
          // setState(() {
          //   print("setState when picfile called");
          //   widget.imageURL = null;
          //   print("widget.imageURL ${widget.imageURL}");
          //
          // });
        },
        positiveButtonText: "From Gallery",
        negativeButton: () async {
          await _takePicture(context, state);
          // setState(() {
          //   print("setState when picfile called");
          //   widget.imageURL = null;
          //   print("widget.imageURL ${widget.imageURL}");
          //
          // });
        },
        negativeButtonText: "Pick From Camera");
  }

  // @override
  // void initState() {
  //   // if (!widget.checkIsEmpty()) {
  //   //   widget.imageURL == null;
  //   // }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return ImagePickerCubit();
      },
      child: Builder(builder: (builderContext) {
        var cubitInst = builderContext.read<ImagePickerCubit>();

        var cubitState = builderContext.watch<ImagePickerCubit>().state;

        if (!cubitState.isInitialized) {
          cubitInst.initLocalImagePickerState(
            // storedImage: storedImage,
            isEnabled: widget.isEnabled,
            imageURL: widget.imageURL,
            title: widget.title,
            localImageURL: widget.localImageURL,
          );
        }
        return InkWell(
          onTap: cubitState.isEnabled
              ? () {
                  _showDialogPickImageFromGalleryOrCamera(
                      builderContext, cubitState);

                  // _pickFile();
                }
              : null,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: sizeHuge * 5,
                  width: sizeHuge * 5,
                  child: Container(
                    // height: sizeHuge * 4,
                    // width:
                    child: (cubitState.imageURL == null)
                        ? cubitState.storedImage == null
                            ? widget.customDefaultIcon ?? Icon(
                                Icons.image,
                                size: sizeHuge * 4,
                                color: Colors.blue,
                              )
                            : Image.file(cubitState.storedImage!, errorBuilder:
                                (BuildContext context, Object exception,
                                    StackTrace? stackTrace) {
                                // setState(() {
                                cubitState.imageURL = null;
                                // });
                                return widget.customDefaultIcon ?? Icon(
                                  Icons.image,
                                  size: sizeHuge * 3,
                                  color: Colors.blue,
                                );
                              })
                        : (cubitState.localImageURL != cubitState.imageURL &&
                                cubitState.localImageURL != null &&
                                cubitState.storedImage != null)
                            ? Image.file(cubitState.storedImage!, errorBuilder:
                                (BuildContext context, Object exception,
                                    StackTrace? stackTrace) {
                                // setState(() {
                                cubitState.imageURL = null;
                                // });
                                return widget.customDefaultIcon ?? Icon(
                                  Icons.image,
                                  size: sizeHuge * 3,
                                  color: Colors.blue,
                                );
                              })
                            : Image.network(
                                cubitState.imageURL!,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  // setState(() {
                                  cubitState.imageURL = null;
                                  // });
                                  return widget.customDefaultIcon ??  Icon(
                                    Icons.image,
                                    size: sizeHuge * 3,
                                    color: Colors.blue,
                                  );
                                },
                              ),
                  ),
                ),
                Visibility(
                    visible: cubitState.title != null,
                    child: Container(
                        padding: EdgeInsets.all(sizeNormal),
                        child: Text("${cubitState.title ?? ""}")))
              ],
            ),
          ),
        );
      }),
    );
  }
}
