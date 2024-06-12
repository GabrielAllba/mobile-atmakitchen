import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atma_kitchen/services/api_saldo.dart'; // Asumsikan ada service API untuk mengakses backend

class CustomerSaldo extends StatefulWidget {
  const CustomerSaldo({super.key});

  @override
  _CustomerSaldoState createState() => _CustomerSaldoState();
}

class _CustomerSaldoState extends State<CustomerSaldo> {
  double _balance = 0.0;
  List<Map<String, dynamic>> _withdrawHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchBalance();
    _fetchWithdrawHistory();
  }

  Future<void> _fetchBalance() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? userId = pref.getInt('id');
    if (userId != null) {
      var response = await ApiSaldo.getUserBalance(userId);
      setState(() {
        _balance = response['balance'];
      });
    }
  }

  Future<void> _fetchWithdrawHistory() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? userId = pref.getInt('id');
    if (userId != null) {
      var response = await ApiSaldo.getWithdrawHistory(userId);
      setState(() {
        _withdrawHistory = response;
      });
    }
  }

  Future<void> _withdrawBalance(double amount) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? userId = pref.getInt('id');
    if (userId != null && amount > 0 && amount <= _balance) {
      await ApiSaldo.withdrawBalance(userId, amount);
      _fetchBalance();
      _fetchWithdrawHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saldo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Saldo Anda: Rp ${_balance.toStringAsFixed(0)}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implementasikan logika untuk menarik saldo
                _showWithdrawDialog();
              },
              child: Text('Tarik Saldo'),
            ),
            SizedBox(height: 20),
            Text('Riwayat Penarikan:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: _withdrawHistory.length,
                itemBuilder: (context, index) {
                  var item = _withdrawHistory[index];
                  return ListTile(
                    title: Text('Rp ${item['amount'].toStringAsFixed(0)}'),
                    subtitle: Text(item['date']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWithdrawDialog() {
    showDialog(
      context: context,
      builder: (context) {
        double amount = 0.0;
        return AlertDialog(
          title: Text('Tarik Saldo'),
          content: TextField(
            onChanged: (value) {
              amount = double.tryParse(value) ?? 0.0;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Masukkan jumlah saldo yang ingin ditarik'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _withdrawBalance(amount);
              },
              child: Text('Tarik'),
            ),
          ],
        );
      },
    );
  }
}
