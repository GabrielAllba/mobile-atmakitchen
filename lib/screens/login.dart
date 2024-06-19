import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atma_kitchen/client/AuthClient.dart'; // Pastikan import AuthClient sudah sesuai dengan struktur proyek Anda
import 'package:atma_kitchen/client/RoleClient.dart'; // Pastikan import RoleClient sudah sesuai dengan struktur proyek Anda
import 'package:atma_kitchen/models/user.dart'; // Pastikan import model User sudah sesuai dengan struktur proyek Anda
import 'package:atma_kitchen/screens/customer/tabs.dart'; // Sesuaikan dengan lokasi tabs untuk customer
import 'package:atma_kitchen/screens/mo/tabs.dart'; // Sesuaikan dengan lokasi tabs untuk manajer operasional

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<http.Response> login() async {
    try {
      final response = await AuthClient.login(
        emailController.text,
        passwordController.text,
      );
      return response;
    } catch (err) {
      return http.Response(err.toString(), 400);
    }
  }

  Future<void> saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = user.id ?? 0;
    await prefs.setInt('id', userId);
    String userJson = json.encode(user.toJson());
    await prefs.setString('user', userJson);
    await printSavedUser();
  }

  Future<void> printSavedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    int? userId = prefs.getInt('id');

    if (userJson != null) {
      Map<String, dynamic> userData = json.decode(userJson);
      print('User Data: $userData');
    }

    if (userId != null) {
      print('User ID: $userId');
    }
  }

  Future<void> navigateTo(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      Map<String, dynamic> userData = json.decode(userJson);
      http.Response res = await RoleClient.getById(userData["role_id"]);
      Map<String, dynamic> role = json.decode(res.body);
      String roleName = role["role"]["name"];

      if (roleName == "Admin" || roleName == "Owner") {
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
          description: Text('Kamu tidak bisa login!'),
          showProgressBar: true,
          autoCloseDuration: const Duration(seconds: 5),
        );
      } else if (roleName == "Customer") {
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
          autoCloseDuration: const Duration(seconds: 5),
        );

        await Future.delayed(
          const Duration(seconds: 2),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const CustomerTabsScreen(),
          ),
        );
      } else if (roleName == "Manajer Operasional") {
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
          autoCloseDuration: const Duration(seconds: 5),
        );

        await Future.delayed(
          const Duration(seconds: 2),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MoTabsScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'images/logo.jpg',
                      width: 80,
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Atma Kitchen',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Masukan Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 0, 0, 0),
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Email harus diisi';
                      }
                      return null;
                    },
                    controller: emailController,
                  ),
                  const SizedBox(height: 16),
                  StatefulBuilder(builder: (context, setState) {
                    return TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.password_outlined),
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 0, 0, 0),
                              width: 2.0,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
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
                      backgroundColor: const Color.fromARGB(255, 255, 229, 1),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        http.Response res = await login();

                        if (res.statusCode == 200) {
                          var responseData = json.decode(res.body);
                          Map<String, dynamic> userData = responseData['user'];

                          User user = User.fromJson(userData);
                          await saveUser(user);
                          await navigateTo(context);
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
                            autoCloseDuration: const Duration(seconds: 5),
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
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ResetPasswordDialog();
                        },
                      );
                    },
                    child: Text('Lupa Password?'),
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

class ResetPasswordDialog extends StatefulWidget {
  @override
  _ResetPasswordDialogState createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> sendResetPasswordEmail(String email) async {
    try {
      final response = await AuthClient.sendResetEmail(email);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        toastification.show(
          type: ToastificationType.success,
          style: ToastificationStyle.flatColored,
          context: context,
          title: Text(
            'Sukses!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          description: Text('Email reset password berhasil dikirim!'),
          showProgressBar: true,
          autoCloseDuration: const Duration(seconds: 5),
        );
      } else {
        toastification.show(
          type: ToastificationType.error,
          style: ToastificationStyle.flatColored,
          context: context,
          title: Text(
            'Gagal!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          description: Text('Gagal mengirim email reset password'),
          showProgressBar: true,
          autoCloseDuration: const Duration(seconds: 5),
        );
      }
    } catch (error) {
      toastification.show(
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        context: context,
        title: Text(
          'Error!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        description: Text('Terjadi kesalahan, coba lagi nanti: $error'),
        showProgressBar: true,
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Reset Password'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Masukan Email',
                prefixIcon: const Icon(Icons.email_outlined),
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 2.0,
                  ),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Email harus diisi';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              sendResetPasswordEmail(_emailController.text);
            }
          },
          child: Text('Kirim'),
        ),
      ],
    );
  }
}