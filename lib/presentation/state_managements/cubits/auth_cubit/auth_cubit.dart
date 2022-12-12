import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/datasource/local/dao/user_dao.dart';
import '../../../../data/model/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  Future<User?> login(String email, String password) async {
    var userDao = UserDao();
    var loggedInUser = await userDao.login(email, password);
    emit(AuthState(user: loggedInUser));
    return state.user;
  }

  // Future<User> getLoggedInUser() {
  //
  // }
}
