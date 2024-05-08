import 'package:atma_kitchen/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoProfile extends StatefulWidget {
  const MoProfile({super.key});

  @override
  State<MoProfile> createState() => _MoProfileState();
}

class _MoProfileState extends State<MoProfile> {
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
                  backgroundColor: const Color.fromARGB(255, 170, 43, 43),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  await logout();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginView(),
                    ),
                  );
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                  ),
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
