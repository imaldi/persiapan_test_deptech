import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persiapan_test_deptech/presentation/state_managements/cubits/catatan_cubit.dart';

import '../../data/model/catatan.dart';

class AddOrEditNotesScreen extends StatefulWidget {
  final Catatan? catatan;

  const AddOrEditNotesScreen({this.catatan, Key? key}) : super(key: key);

  @override
  _AddOrEditNotesScreenState createState() => _AddOrEditNotesScreenState();
}

class _AddOrEditNotesScreenState extends State<AddOrEditNotesScreen> {
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var descController = TextEditingController();
  var pengingatDateController = TextEditingController();
  var intervalController = TextEditingController();
  var isCreateNew = true;
  var isPengingat = false;
  DateTime? dateTimePengingat;

  @override
  void initState() {
    super.initState();
    isCreateNew = widget.catatan == null;
    isPengingat = (widget.catatan?.waktuPengingat != null && widget.catatan?.intervalPengingat != null);
    titleController.text = widget.catatan?.title ?? "";
    descController.text = widget.catatan?.description ?? "";
    pengingatDateController.text = widget.catatan?.waktuPengingat.toString() == "null" ? "" : (widget.catatan?.waktuPengingat.toString() ?? "");
    intervalController.text = (widget.catatan?.intervalPengingat ?? 0).toString() ?? "";
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
                                var res = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1990),
                                    lastDate: DateTime(2100));
                                if (res != null && isPengingat) {
                                  pengingatDateController.text = res.toString();
                                  dateTimePengingat = res;
                                }
                              }
                                  : null,
                              child: Container(
                                // padding: EdgeInsets.all(size_medium),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),),
                                child: TextFormField(
                                    controller: pengingatDateController,
                                    enabled: false,
                                    validator: (val) {
                                      if ((val ?? "").isEmpty && isPengingat) {
                                        return "Field ini tidak boleh kosong";
                                      }
                                      return null;
                                    },
                                    decoration:
                                    const InputDecoration(label: Text("Pengingat Date"))),
                              ),
                            ),
                        TextFormField(
                            controller: intervalController,
                            keyboardType: TextInputType.number,
                            enabled: isPengingat,
                            validator: (val) {
                              if ((val ?? "").isEmpty && isPengingat) {
                                return "Field ini tidak boleh kosong";
                              }
                              return null;
                            },
                            decoration:
                                const InputDecoration(label: Text("Interval Pengingat"))),
                        ElevatedButton(
                            onPressed: () {
                              if ((formKey.currentState?.validate() ?? false)) {
                                formKey.currentState?.save();
                                var responseToSend = Catatan(
                                    id: widget.catatan?.id,
                                    title: titleController.text,
                                    description: descController.text,
                                    waktuPengingat: isPengingat ? dateTimePengingat : null,
                                    intervalPengingat: int.parse(intervalController.text)
                                );
                                isCreateNew
                                    ? context
                                        .read<CatatanCubit>()
                                        .addCatatan(responseToSend)
                                    : context
                                        .read<CatatanCubit>()
                                        .editCatatan(responseToSend);
                                Navigator.of(context).pop();
                              }
                            },
                            child:
                                Text("${isCreateNew ? "Add" : "Update"} Note"))
                      ])
                      // Container(
                      //     margin: const EdgeInsets.symmetric(vertical: 16),
                      //     child: BlocListener<PostsBloc, PostsState>(
                      //       listener: (context, state) {
                      //         if (state is CreatePostsSuccess) {
                      //           myToast("Success Creating Post");
                      //           Navigator.of(context).pop();
                      //         }
                      //
                      //         if (state is UpdatePostsSuccess) {
                      //           myToast("Success Update Post");
                      //           Navigator.of(context).pop();
                      //         }
                      //
                      //         if (state is CreatePostsFailed) {
                      //           myToast("Failed Creating Post: ${state.errorMessage}");
                      //         }
                      //
                      //         if (state is UpdatePostsFailed) {
                      //           myToast("Failed Updating Post: ${state.errorMessage}");
                      //         }
                      //       },
                      //       child: BlocBuilder<PostsBloc, PostsState>(
                      //         builder: (context, state) {
                      //           if(state is LoadingPosts){
                      //             return const CircularProgressIndicator();
                      //           }
                      //           return ElevatedButton(
                      //               onPressed: () {
                      //                 if ((formKey.currentState?.validate() ??
                      //                     false)) {
                      //                   formKey.currentState?.save();
                      //                   var responseToSend = PostsResponse(
                      //                       id: widget.postsResponse?.id ?? 1,
                      //                       userId: 1,
                      //                       title: titleController.text,
                      //                       body: descController.text);
                      //                   var eventToAdd =
                      //                   widget.postsResponse == null
                      //                       ? CreateAPosts(responseToSend)
                      //                       : UpdateAPosts(responseToSend);
                      //                   context
                      //                       .read<PostsBloc>()
                      //                       .add(eventToAdd);
                      //                 }
                      //               },
                      //               child: Text(
                      //                   "${widget.postsResponse == null ? "Create" : "Update"} Post"));
                      //         },
                      //       ),
                      //     ))
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
