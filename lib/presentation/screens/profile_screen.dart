import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persiapan_test_deptech/data/model/user.dart';
import 'package:persiapan_test_deptech/presentation/state_managements/cubits/auth_cubit/auth_cubit.dart';
import 'package:persiapan_test_deptech/presentation/widgets/my_image_picker/my_image_picker.dart';
import 'package:persiapan_test_deptech/presentation/widgets/my_toast.dart';

import '../../core/consts/numbers.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var namaDepanController = TextEditingController();
  var namaBelakangController = TextEditingController();
  var emailController = TextEditingController();
  var tanggalLahirController = TextEditingController();
  var jenisKelaminController = TextEditingController();
  var fotoProfilController = TextEditingController();
  var jenisKelamin = "L";
  DateTime? tanggalLahir;

  @override
  void initState() {
    super.initState();
    var user = context.read<AuthCubit>().state.user ?? User();
    namaDepanController.text = user.namaDepan ?? '';
    namaBelakangController.text = user.namaBelakang ?? '';
    emailController.text = user.email ?? '';
    tanggalLahirController.text = user.tanggalLahir.toString() ?? '';
    tanggalLahir = user.tanggalLahir;
    jenisKelaminController.text = user.jenisKelamin ?? '';
    fotoProfilController.text = user.fotoProfil ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Screen"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 100,
                    child: Center(
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          MyImagePickerWidget(
                            (theImage) {
                              fotoProfilController.text = theImage?.path ?? "";
                            },
                            localImageURL: fotoProfilController.text,
                            customDefaultIcon: Icon(
                              Icons.person,
                              size: sizeHuge * 3,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              myToast("Tap foto profil untuk edit");
                            },
                            child: CircleAvatar(
                                radius: sizeHuge,
                                backgroundColor: Colors.blueAccent,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: sizeHuge,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextFormField(
                      controller: namaDepanController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (val) {
                        if ((val ?? "").isEmpty) {
                          return "Field ini tidak boleh kosong";
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(label: Text("Nama Depan"))),
                  TextFormField(
                      controller: namaBelakangController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (val) {
                        if ((val ?? "").isEmpty) {
                          return "Field ini tidak boleh kosong";
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(label: Text("Nama Belakang"))),
                  TextFormField(
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (val) {
                        if ((val ?? "").isEmpty) {
                          return "Field ini tidak boleh kosong";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(label: Text("Email"))),
                  TextFormField(
                      controller: tanggalLahirController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (val) {
                        if ((val ?? "").isEmpty) {
                          return "Field ini tidak boleh kosong";
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(label: Text("Tanggal Lahir"))),
                  // TextFormField(
                  //     controller: jenisKelaminController,
                  //     autovalidateMode: AutovalidateMode.onUserInteraction,
                  //     validator: (val) {
                  //       if ((val ?? "").isEmpty) {
                  //         return "Field ini tidak boleh kosong";
                  //       }
                  //       return null;
                  //     },
                  //     decoration:
                  //         const InputDecoration(label: Text("Jenis Kelamin"))),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: sizeMedium),
                    child: Row(children: [
                      Text("Jenis Kelamin")
                    ],),
                  ),
                  Row(
                    children: [
                      Radio<String>(value: "L",groupValue: jenisKelaminController.text,onChanged: (val){
                        setState(() {
                          jenisKelaminController.text = val ?? "L";
                        });
                      }),
                      Text("Pria"),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(value: "P",groupValue: jenisKelaminController.text,onChanged: (val){
                        setState(() {
                          jenisKelaminController.text = val ?? "P";
                        });
                      },),
                      Text("Wanita")
                    ],
                  ),
                  // TextFormField(
                  //     controller: fotoProfilController,
                  //     autovalidateMode: AutovalidateMode.onUserInteraction,
                  //     validator: (val) {
                  //       if ((val ?? "").isEmpty) {
                  //         return "Field ini tidak boleh kosong";
                  //       }
                  //       return null;
                  //     },
                  //     decoration:
                  //         const InputDecoration(label: Text("Foto Profil"))),
                  ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().updateUser(
                                // context.read<AuthCubit>().state.user ??
                                User(
                              id: context.read<AuthCubit>().state.user?.id ?? 0,
                              namaDepan: namaDepanController.text,
                              namaBelakang: namaBelakangController.text,
                              email: emailController.text,
                              tanggalLahir: tanggalLahir,
                              password: context.read<AuthCubit>().state.user?.password ?? "",
                              jenisKelamin: jenisKelaminController.text,
                              fotoProfil: fotoProfilController.text,
                            ));
                        myToast("Success Edit Profile");
                        Navigator.of(context).pop();
                      },
                      child: Text("Update Profil"))
                ],
              )),
        ),
      ),
    );
  }
}
