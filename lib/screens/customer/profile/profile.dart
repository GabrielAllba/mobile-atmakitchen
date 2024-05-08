import 'package:atma_kitchen/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({super.key});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 229, 1),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  await logout();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginView(), // Replace LoginScreen
                    ),
                  );
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}
