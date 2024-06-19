import 'package:flutter/material.dart';
import 'package:atma_kitchen/screens/customer/home.dart';
import 'package:atma_kitchen/screens/customer/profile/profile.dart';
import 'package:atma_kitchen/screens/customer/saldo/saldo.dart';
import 'package:atma_kitchen/screens/customer/pesanan/customer_pesanan_filtered.dart';

class CustomerTabsScreen extends StatefulWidget {
  const CustomerTabsScreen({super.key});

  @override
  State<CustomerTabsScreen> createState() => _CustomerTabsScreenState();
}

class _CustomerTabsScreenState extends State<CustomerTabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const CustomerHome();

    if (_selectedPageIndex == 0) {
      activePage = const CustomerHome();
    } else if (_selectedPageIndex == 1) {
      activePage = const CustomerSaldo();
    } else if (_selectedPageIndex == 2) {
      activePage = const CustomerPesananFiltered(); // Use the filtered view
    } else if (_selectedPageIndex == 3) {
      activePage = const CustomerProfile();
    }

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Saldo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined),
            label: 'Pengiriman', // Update label if needed
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
