import 'package:flutter/material.dart';
import 'package:persiapan_test_deptech/data/datasource/local/dao/catatan_dao.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CatatanDao catatanDao;
  @override
  void initState() {
  super.initState();
  catatanDao = CatatanDao();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Note App"),),
      body: SingleChildScrollView(child: FutureBuilder(
        future: catatanDao.catatanList(setState),
        builder: (c,snapshot){
          return snapshot.hasData ?

            Text("${snapshot.data}") : const Center(child: CircularProgressIndicator(),);
            // ListView.builder(
            //   scrollDirection:Axis.vertical,
            //   physics: const NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   itemCount: snapshot.data?.length,
            //   itemBuilder: (c,i){
            //     return ListTile(title: Text("${snapshot.data?[i].title}"),subtitle: Text("${snapshot.data?[i].description}"),);
            //   });
        },
      ),),
    );
  }
}
