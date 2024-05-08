import 'package:flutter/material.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => CustomerHomeState();
}

class CustomerHomeState extends State<CustomerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Text("Customer Home Screen"),
      )),
    );
  }
}
