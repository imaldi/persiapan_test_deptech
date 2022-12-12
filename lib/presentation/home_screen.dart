import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persiapan_test_deptech/data/datasource/local/dao/catatan_dao.dart';
import 'package:persiapan_test_deptech/presentation/state_managements/cubits/catatan_cubit.dart';

import '../data/model/catatan.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CatatanCubit>().initList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note App"),
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
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context
              .read<CatatanCubit>()
              .addCatatan(Catatan(title: "HEEYY", description: "HUUUY"));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
