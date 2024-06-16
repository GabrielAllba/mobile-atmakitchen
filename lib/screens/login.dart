import 'dart:convert';
import 'package:atma_kitchen/client/AuthClient.dart';
import 'package:atma_kitchen/client/RoleClient.dart';
import 'package:atma_kitchen/models/user.dart';
import 'package:atma_kitchen/screens/customer/tabs.dart';
import 'package:atma_kitchen/screens/mo/tabs.dart';
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
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
  }

  Future<Response> login() async {
    try {
      Response res = await AuthClient.login(
        emailController.text,
        passwordController.text,
      );
      return res;
    } catch (err) {
      return Response(err.toString(), 400);
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
                  const SizedBox(height: 16), // Add some spacing between fields
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
                        Response res = await login();

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
  // Handling nullable user.id
  int userId = user.id ?? 0; // Default to 0 if user.id is null
  await prefs.setInt('id', userId); // Save user ID
  String userJson = json.encode(user.toJson()); // Assuming toJson() method exists in User model
  await prefs.setString('user', userJson); // Save user data as JSON string
  await printSavedUser(); // Optional: Print saved user data for debugging
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
  print('User JSON: $userJson'); // Tambahkan pernyataan print untuk debug
  if (userJson != null) {
    Map<String, dynamic> userData = json.decode(userJson);
    print('User Data: $userData'); // Tambahkan pernyataan print untuk debug
    print('User Role ID: ${userData["role_id"]}'); // Tambahkan pernyataan print untuk debug
    Response res = await RoleClient.getById(userData["role_id"]);
    Map<String, dynamic> role = json.decode(res.body);
    String roleName = role["role"]["name"];
    print('Role Name: $roleName'); // Tambahkan pernyataan print untuk debug

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

      Navigator.pushReplacement( // Menggunakan pushReplacement agar tidak bisa kembali ke halaman login dengan tombol back
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
