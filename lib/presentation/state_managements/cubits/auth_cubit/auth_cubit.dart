import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../../../data/datasource/local/dao/user_dao.dart';
import '../../../../data/model/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  Future<User?> login(String email, String password) async {
    var userDao = UserDao();
    var loggedInUser = await userDao.login(email, password);
    final LocalStorage storage = LocalStorage('note_app');
    if(loggedInUser != null){
      await storage.setItem('logged_in_user', loggedInUser.toMap());
    }
    emit(AuthState(user: loggedInUser));
    return state.user;
  }

  Future<void> updateUser(User user) async {
    var userDao = UserDao();
    await userDao.updateUser(user);
    var newUser = await login(user.email!,user.password!);
    emit(AuthState(user: newUser ?? User()));
  }

  Future<void> checkLogin(Function() onLoggedIn) async {
    final LocalStorage storage = LocalStorage('note_app');
    await storage.ready;
    Map<String, dynamic> userMap = storage.getItem('logged_in_user') ?? {};
    if(userMap.isNotEmpty) {
      emit(AuthState(user: User.fromMap(userMap)));
      onLoggedIn();
    }
  }
  Future<void> saveFile(File file) async {
    print("Old Path: ${file.path}");
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    var savedFile = await file.copy('${appDocumentsPath}/user_profile.jpg');
    print("New Path: ${savedFile.path}");
    emit(AuthState(user: state.user?.copyWith(fotoProfil: savedFile.path)));
  }

  Future<void> logOut() async {
    final LocalStorage storage = LocalStorage('note_app');
    storage.clear();
  }
}
