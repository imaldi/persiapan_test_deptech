import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persiapan_test_deptech/core/consts/numbers.dart';
import 'package:persiapan_test_deptech/presentation/state_managements/cubits/catatan_cubit.dart';

import '../../core/helper/duration_minute_to_human_readable.dart';
import '../../data/model/catatan.dart';
import '../widgets/my_file_picker.dart';

class AddOrEditNotesScreen extends StatefulWidget {
  final Catatan? catatan;

  const AddOrEditNotesScreen({this.catatan, Key? key}) : super(key: key);

  @override
  _AddOrEditNotesScreenState createState() => _AddOrEditNotesScreenState();
}

class _AddOrEditNotesScreenState extends State<AddOrEditNotesScreen> {
  var formKey = GlobalKey<FormState>();
  var durationKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var descController = TextEditingController();
  var pengingatDateController = TextEditingController();
  var intervalController = TextEditingController();
  var hariController = TextEditingController();
  var jamController = TextEditingController();
  var menitController = TextEditingController();
  var isCreateNew = true;
  var isPengingat = false;
  var filePath = "";
  var reminderInterval = 0;
  DateTime? dateTimePengingat;

  @override
  void initState() {
    super.initState();
    isCreateNew = widget.catatan == null;
    isPengingat = (widget.catatan?.waktuPengingat != null &&
        widget.catatan?.intervalPengingat != null);
    filePath = widget.catatan?.lampiran ?? "";
    reminderInterval = widget.catatan?.intervalPengingat ?? 0;
    titleController.text = widget.catatan?.title ?? "";
    descController.text = widget.catatan?.description ?? "";
    pengingatDateController.text =
        widget.catatan?.waktuPengingat.toString() == "null"
            ? ""
            : (widget.catatan?.waktuPengingat.toString() ?? "");
    intervalController.text = (durationMinuteToHumanReadable(
                widget.catatan?.intervalPengingat ?? 0) ??
            "")
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.catatan == null ? "Add" : "Edit"} Note"),
        actions: [
          Switch(
            value: isPengingat,
            onChanged: (val) {
              setState(() {
                isPengingat = !isPengingat;
              });
            },
            activeColor: Colors.lightBlue,
            activeTrackColor: Colors.blueGrey,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: formKey,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: IntrinsicHeight(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Text(isCreateNew ? "Create new note" : "Update a note"),
                        TextFormField(
                            controller: titleController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (val) {
                              if ((val ?? "").isEmpty) {
                                return "Field ini tidak boleh kosong";
                              }
                              return null;
                            },
                            decoration:
                                const InputDecoration(label: Text("Title"))),
                        TextFormField(
                          controller: descController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (val) {
                            if ((val ?? "").isEmpty) {
                              return "Field ini tidak boleh kosong";
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(label: Text("Description")),
                          minLines: 5,
                          maxLines: 5,
                        ),
                        InkWell(
                          onTap: isPengingat
                              ? () async {
                                  FocusScope.of(context).unfocus();
                                  var res = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1990),
                                      lastDate: DateTime(2100));
                                  if (res != null && isPengingat) {
                                    pengingatDateController.text =
                                        res.toString();
                                    dateTimePengingat = res;
                                  }
                                }
                              : null,
                          child: Container(
                            // padding: EdgeInsets.all(size_medium),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextFormField(
                                controller: pengingatDateController,
                                enabled: false,
                                validator: (val) {
                                  if ((val ?? "").isEmpty && isPengingat) {
                                    return "Field ini tidak boleh kosong";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    label: Text("Pengingat Date"))),
                          ),
                        ),
                        InkWell(
                          onTap: isPengingat
                              ? () async {
                                  FocusScope.of(context).unfocus();
                                  await showDialog(
                                    context: context,
                                    builder: (c) {
                                      return AlertDialog(
                                        title: const Text("Reminder Interval"),
                                        content: Form(
                                          key: durationKey,
                                          child: IntrinsicHeight(
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                    controller: hariController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    validator: (val) {
                                                      if ((val ?? "").isEmpty) {
                                                        return "Field ini tidak boleh kosong";
                                                      }
                                                      return null;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                            label:
                                                                Text("Hari"))),
                                                TextFormField(
                                                    controller: jamController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    validator: (val) {
                                                      if ((val ?? "").isEmpty) {
                                                        return "Field ini tidak boleh kosong";
                                                      }
                                                      if (int.parse(
                                                                  val ?? "0") >=
                                                              24 ||
                                                          int.parse(
                                                                  val ?? "0") <
                                                              0) {
                                                        return "Durasi jam hanya dari 0 - 23";
                                                      }
                                                      return null;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                            label:
                                                                Text("Jam"))),
                                                TextFormField(
                                                    controller: menitController,
                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    validator: (val) {
                                                      if ((val ?? "").isEmpty) {
                                                        return "Field ini tidak boleh kosong";
                                                      }
                                                      if (int.parse(
                                                          val ?? "0") >=
                                                          60 ||
                                                          int.parse(
                                                              val ?? "0") <
                                                              0) {
                                                        return "Durasi menit hanya dari 0 - 59";
                                                      }
                                                      return null;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                            label:
                                                                Text("Menit"))),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                if ((durationKey.currentState
                                                        ?.validate() ??
                                                    false)) {
                                                  durationKey.currentState?.save();
                                                reminderInterval = int.parse(
                                                            hariController
                                                                .text) *
                                                        24 *
                                                        60 +
                                                    int.parse(jamController
                                                            .text) *
                                                        60 +
                                                    int.parse(
                                                        menitController.text);
                                                intervalController.text =
                                                    durationMinuteToHumanReadable(
                                                        reminderInterval);
                                                Navigator.of(context).pop();
                                                } else {
                                                  jamController.text = "";
                                                  menitController.text = "";
                                                }
                                              },
                                              child: Text("OK")),
                                          // Text("Oke"),
                                        ],
                                        actionsAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                      );
                                    },
                                  );
                                }
                              : null,
                          child: TextFormField(
                              controller: intervalController,
                              keyboardType: TextInputType.number,
                              // enabled: isPengingat,
                              enabled: false,
                              onTap: () {
                                FocusScope.of(context).unfocus();
                              },
                              validator: (val) {
                                if ((val ?? "").isEmpty && isPengingat) {
                                  return "Field ini tidak boleh kosong";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  label: Text("Interval Pengingat"))),
                        ),
                        Row(
                          children: const [
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: sizeMedium),
                              child: Text(
                                "Lampiran",
                                style: TextStyle(fontSize: sizeMedium),
                              ),
                            ),
                          ],
                        ),
                        MyFilePickerWidget((theFile) {
                          setState(() {
                            filePath = theFile?.path ?? "";
                          });
                        },
                        fileURL: filePath,
                        ),
                        // Text("filePath: $filePath"),
                        ElevatedButton(
                            onPressed: () {
                              if ((formKey.currentState?.validate() ?? false)) {
                                formKey.currentState?.save();
                                var responseToSend = Catatan(
                                  id: widget.catatan?.id,
                                  title: titleController.text,
                                  description: descController.text,
                                  waktuPengingat:
                                      isPengingat ? dateTimePengingat : null,
                                  intervalPengingat: reminderInterval,
                                  // intervalController.text.isNotEmpty ?
                                  //     int.parse(intervalController.text) : null,
                                  lampiran: filePath,
                                );
                                isCreateNew
                                    ? context
                                        .read<CatatanCubit>()
                                        .addCatatan(responseToSend)
                                    : context
                                        .read<CatatanCubit>()
                                        .editCatatan(responseToSend);
                                Navigator.of(context).pop();
                              } else {}
                            },
                            child:
                                Text("${isCreateNew ? "Add" : "Update"} Note"))
                      ])),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
