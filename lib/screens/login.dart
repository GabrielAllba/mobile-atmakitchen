import 'dart:convert';

import 'package:atma_kitchen/client/AuthClient.dart';
import 'package:atma_kitchen/models/user.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void initState() {
    super.initState();
  }

  Future<Response> login() async {
    print("object");
    try {
      Response res = await AuthClient.login(
        emailController.text,
        passwordController.text,
      );
      print("asdfadsfasdf");
      print(res);
      return res;
    } catch (err) {
      print("error bang");
      return Response(err.toString(), 400);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _obscurePassword =
        true; // State variable to toggle password visibility

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Atma Kitchen',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 170, 43, 43),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Masukan Email',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Email harus diisi';
                      }
                      return null;
                    },
                    controller: emailController,
                  ),
                  const SizedBox(height: 16), // Add some spacing between fields
                  StatefulBuilder(builder: (context, setState) {
                    return TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          )),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Password harus diisi';
                        }
                        return null;
                      },
                    );
                  }),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 170, 43, 43), // Background color
                      minimumSize:
                          const Size(double.infinity, 50), // Full width button
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Response res = await login();

                        if (res.statusCode == 200) {
                          var responseData = json.decode(res.body);
                          Map<String, dynamic> userData = responseData['user'];

                          User user = User.fromJson(userData);
                          saveUser(user);

                          toastification.show(
                            type: ToastificationType.success,
                            style: ToastificationStyle.flatColored,
                            context: context,
                            title: Text(
                              'Sukses!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            description: Text('Selamat, kamu berhasil login!'),
                            showProgressBar: true,
                            // autoCloseDuration: const Duration(seconds: 3),
                          );

                          await Future.delayed(
                            const Duration(seconds: 2),
                          );
                        } else {
                          toastification.show(
                            type: ToastificationType.error,
                            style: ToastificationStyle.flatColored,
                            context: context,
                            title: Text(
                              'Gagal Login!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            description: Text('Email dan password harus benar'),
                            showProgressBar: true,
                            // autoCloseDuration: const Duration(seconds: 3),
                          );

                          await Future.delayed(
                            const Duration(seconds: 2),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                      ), // Set text color to white
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> saveUser(User user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userJson = user.toRawJson();
  await prefs.setString('user', userJson);
  await printSavedUser();
}

Future<void> printSavedUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userJson = prefs.getString('user');

  if (userJson != null) {
    Map<String, dynamic> userData = json.decode(userJson);
    print(userData);
    print(userData['password']);
  }
}
