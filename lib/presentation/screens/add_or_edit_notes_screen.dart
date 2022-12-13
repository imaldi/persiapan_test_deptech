import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persiapan_test_deptech/core/consts/numbers.dart';
import 'package:persiapan_test_deptech/presentation/state_managements/cubits/catatan_cubit.dart';
import 'package:persiapan_test_deptech/presentation/widgets/my_toast.dart';

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
  var reminderIntervalInMinute = 0;
  DateTime? dateTimePengingat;

  @override
  void initState() {
    super.initState();
    isCreateNew = widget.catatan == null;
    isPengingat = (widget.catatan?.waktuPengingat != null &&
        widget.catatan?.intervalPengingat != null);
    filePath = widget.catatan?.lampiran ?? "";
    reminderIntervalInMinute = (widget.catatan?.intervalPengingat ?? 0) ~/ 60;
    dateTimePengingat = widget.catatan?.waktuPengingat;
    myToast("reminder Init: $reminderIntervalInMinute");
    myToast("reminder Init readable: ${durationMinuteToHumanReadable(reminderIntervalInMinute)}");
    titleController.text = widget.catatan?.title ?? "";
    descController.text = widget.catatan?.description ?? "";
    pengingatDateController.text =
        widget.catatan?.waktuPengingat.toString() == "null"
            ? ""
            : (widget.catatan?.waktuPengingat.toString() ?? "");
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(children: [
                            Text("Interval Reminder")
                          ],),
                        ),
                        Row(
                          children: [
                            DropdownButton<int>(
                                value: reminderIntervalInMinute,
                                items: const [
                                  DropdownMenuItem(child: Text("Tidak Ada"),value: 0,),
                                  DropdownMenuItem(child: Text("1 Hari Sebelumnya"),value: 60*24,),
                                  DropdownMenuItem(child: Text("3 Jam Sebelumnya"),value: 180,),
                                  DropdownMenuItem(child: Text("1 Jam Sebelumnya"),value: 60,),
                                ], onChanged: isPengingat ? (val){
                                  setState((){
                                    reminderIntervalInMinute = val ?? 0;

                                  });
                                  // myToast("reminderIntervalInMinute: $reminderIntervalInMinute");
                            }: null),
                          ],
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
                                  intervalPengingat: isPengingat ? reminderIntervalInMinute * 60  : null,
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
                                if(reminderIntervalInMinute > 0){
                                  // popUpReminder((responseToSend.intervalPengingat ?? 0) ~/ 60);
                                  durationMinuteToHumanReadable((responseToSend.intervalPengingat ?? 0) ~/ 60,callback: (val){
                                    myToast("Reminder in $val");
                                  });

                                }
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
