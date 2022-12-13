import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persiapan_test_deptech/data/model/user.dart';
import 'package:persiapan_test_deptech/presentation/state_managements/cubits/auth_cubit/auth_cubit.dart';

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
  @override
  void initState() {
    super.initState();
    var user = context.read<AuthCubit>().state.user ?? User();
    namaDepanController.text = user.namaDepan ?? '';
    namaBelakangController.text = user.namaBelakang ?? '';
    emailController.text = user.email ?? '';
    tanggalLahirController.text = user.tanggalLahir.toString() ?? '';
    jenisKelaminController.text = user.jenisKelamin ?? '';
    fotoProfilController.text = user.fotoProfil ?? '';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Screen"),),
      body: Center(child: Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  controller: namaDepanController,
                  autovalidateMode:
                  AutovalidateMode.onUserInteraction,
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
                  autovalidateMode:
                  AutovalidateMode.onUserInteraction,
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
                  autovalidateMode:
                  AutovalidateMode.onUserInteraction,
                  validator: (val) {
                    if ((val ?? "").isEmpty) {
                      return "Field ini tidak boleh kosong";
                    }
                    return null;
                  },
                  decoration:
                  const InputDecoration(label: Text("Email"))),
              TextFormField(
                  controller: tanggalLahirController,
                  autovalidateMode:
                  AutovalidateMode.onUserInteraction,
                  validator: (val) {
                    if ((val ?? "").isEmpty) {
                      return "Field ini tidak boleh kosong";
                    }
                    return null;
                  },
                  decoration:
                  const InputDecoration(label: Text("Tanggal Lahir"))),
              TextFormField(
                  controller: jenisKelaminController,
                  autovalidateMode:
                  AutovalidateMode.onUserInteraction,
                  validator: (val) {
                    if ((val ?? "").isEmpty) {
                      return "Field ini tidak boleh kosong";
                    }
                    return null;
                  },
                  decoration:
                  const InputDecoration(label: Text("Jenis Kelamin"))),
              TextFormField(
                  controller: fotoProfilController,
                  autovalidateMode:
                  AutovalidateMode.onUserInteraction,
                  validator: (val) {
                    if ((val ?? "").isEmpty) {
                      return "Field ini tidak boleh kosong";
                    }
                    return null;
                  },
                  decoration:
                  const InputDecoration(label: Text("Foto Profil"))),
              ElevatedButton(onPressed: (){
                context.read<AuthCubit>().updateUser(context.read<AuthCubit>().state.user ?? const User());
              }, child: Text("Update Profil"))
            ],
          )),),
    );
  }
}
