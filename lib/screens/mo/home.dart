import 'package:flutter/material.dart';

class MoHome extends StatefulWidget {
  const MoHome({super.key});

  @override
  State<MoHome> createState() => MoHomeState();
}

class MoHomeState extends State<MoHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Text("MO Home Screen"),
      )),
    );
  }
}
