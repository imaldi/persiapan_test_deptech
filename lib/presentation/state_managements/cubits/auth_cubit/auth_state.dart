part of 'auth_cubit.dart';

class AuthState extends Equatable {
  User? user;
  AuthState({
    this.user
});
  @override
  List<Object?> get props => [user];
}
