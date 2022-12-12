import 'package:flutter/material.dart';
import 'package:persiapan_test_deptech/data/datasource/local/dao/user_dao.dart';
import 'package:persiapan_test_deptech/presentation/screens/home_screen.dart';
import 'package:persiapan_test_deptech/presentation/widgets/my_toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
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
                        Text("Login"),
                        TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
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
                            controller: passwordController,
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            obscureText: true,
                            validator: (val) {
                              if ((val ?? "").isEmpty) {
                                return "Field ini tidak boleh kosong";
                              }
                              return null;
                            },
                            decoration:
                            const InputDecoration(label: Text("Password"))),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                if ((formKey.currentState
                                    ?.validate() ??
                                    false)) {
                                  formKey.currentState?.save();
                                  /// TODO check db and then set session
                                  var userDao = UserDao();
                                  var loggedInUser = await userDao.login(emailController.text, passwordController.text);
                                  if(loggedInUser == null){
                                    myToast("Email atau Password salah");
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const HomeScreen(),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Text("Login")),
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
