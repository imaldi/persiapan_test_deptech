import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';
import 'package:persiapan_test_deptech/core/consts/numbers.dart';
import 'package:persiapan_test_deptech/presentation/screens/add_or_edit_notes_screen.dart';
import 'package:persiapan_test_deptech/presentation/screens/login_screen.dart';
import 'package:persiapan_test_deptech/presentation/screens/profile_screen.dart';
import 'package:persiapan_test_deptech/presentation/state_managements/cubits/auth_cubit/auth_cubit.dart';
import 'package:persiapan_test_deptech/presentation/state_managements/cubits/catatan_cubit.dart';

import '../../data/model/catatan.dart';
import '../../data/model/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User user;
  @override
  void initState() {
    super.initState();
    context.read<CatatanCubit>().initList();
    user = context.read<AuthCubit>().state.user ?? const User(namaDepan: "Guest");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note App of ${user.namaDepan}"),
        actions: [
          InkWell(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeMedium),
              child: Icon(Icons.person),
            ),
          ),
          InkWell(
            onTap: (){
              context.read<AuthCubit>().logOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeMedium),
              child: Icon(Icons.logout),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Builder(
          builder: (c) {
            var state = c.watch<CatatanCubit>().state;
            return (state.catatanList ?? []).isNotEmpty
                ?

                // Text("${state.catatanList}") : const Center(child: CircularProgressIndicator(),);
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.catatanList?.length,
                    itemBuilder: (c, i) {
                      return ListTile(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddOrEditNotesScreen(catatan: state.catatanList?[i],),
                            ),
                          );
                        },
                        title: Text("${state.catatanList?[i].title}"),
                        subtitle: Text("${state.catatanList?[i].description}"),
                        trailing: InkWell(
                            onTap: (){
                              c.read<CatatanCubit>().deleteCatatan(state.catatanList?[i].id ?? 0);
                            },
                            child: const Icon(Icons.delete)),
                      );
                    })
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text("No Notes Found"),
                    ),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // context
          //     .read<CatatanCubit>()
          //     .addCatatan(Catatan(title: "HEEYY", description: "HUUUY"));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddOrEditNotesScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
