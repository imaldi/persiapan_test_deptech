import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persiapan_test_deptech/data/datasource/local/dao/user_dao.dart';
import 'package:persiapan_test_deptech/presentation/screens/home_screen.dart';
import 'package:persiapan_test_deptech/presentation/screens/login_screen.dart';
import 'package:persiapan_test_deptech/presentation/state_managements/cubits/auth_cubit/auth_cubit.dart';
import 'package:persiapan_test_deptech/presentation/state_managements/cubits/catatan_cubit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import 'data/model/user.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>CatatanCubit()),
        BlocProvider(create: (_)=>AuthCubit()),
      ],
      child: MaterialApp(
        title: 'Note App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:
        // const LoginScreen()
        Builder(
          builder: (context) {
            return const LoginScreen();
            // return const HomeScreen();
          }
        ),
        // const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late UserDao userDao;

  @override
  void initState() {
    super.initState();
    userDao = UserDao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'User:',
            ),
            FutureBuilder(
              future: userDao.getLoggedInUser(1),
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data}',
                  style: Theme.of(context).textTheme.headline4,
                );
              }
            ),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// Define a function that inserts dogs into the database

