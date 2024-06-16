import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atma_kitchen/services/api_saldo.dart'; // Assuming this is your API service
import 'package:intl/intl.dart'; // Import paket intl untuk menggunakan NumberFormat

class CustomerSaldo extends StatefulWidget {
  const CustomerSaldo({Key? key}) : super(key: key);

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
      try {
        double response = await ApiSaldo.getUserBalance(userId);
        setState(() {
          _balance = response;
        });
      } catch (e) {
        print('Failed to fetch balance: $e');
      }
    }
  }

  Future<void> _fetchWithdrawHistory() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? userId = pref.getInt('id');
    if (userId != null) {
      try {
        List<Map<String, dynamic>> response =
            await ApiSaldo.getWithdrawHistory(userId);
        print('Withdraw history response: $response');
        setState(() {
          _withdrawHistory = response;
        });
      } catch (e) {
        print('Failed to fetch withdraw history: $e');
      }
    } else {
      print('User ID not found in SharedPreferences');
    }
  }

  Future<void> _withdrawBalance(
      double amount, String bankName, String accountNo) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? userId = pref.getInt('id');
    if (userId != null && amount > 0 && amount <= _balance) {
      try {
        await ApiSaldo.withdrawBalance(
            userId, amount, bankName, accountNo); // Assuming API is updated
        print('Withdraw successful');
        _fetchBalance();
        _fetchWithdrawHistory();
      } catch (e) {
        print('Failed to withdraw balance: $e');
      }
    } else {
      print('Invalid withdraw amount or user ID');
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
            Text(
              'Saldo Anda: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(_balance)}',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
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

                  // Format tanggal dan waktu dari created_at
                  var formattedDate = item['created_at'] != null
                      ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(item['created_at']))
                      : ''; // Atur format tanggal dan waktu sesuai kebutuhan

                  var amountFormatted = NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp',
                    decimalDigits: 0,
                  ).format(item['amount']);

                  var statusText = item['status'] ?? '';
                  var bankNameText = item['bank_name'] ?? '';
                  var accountNoText = item['account_no'] ?? '';

                  return ListTile(
                    title: Text(amountFormatted),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanggal: $formattedDate'),
                        Text('Status: $statusText'),
                        Text('Bank: $bankNameText'),
                        Text('Account No: $accountNoText'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController amountController = TextEditingController();

  void _showWithdrawDialog() {
    String bankName = '';
    String accountNo = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tarik Saldo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                enabled: false,
                decoration: InputDecoration(
                  hintText: NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp',
                    decimalDigits: 0,
                  ).format(_balance),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                onChanged: (value) {
                  bankName = value;
                },
                decoration: InputDecoration(
                  hintText: 'Masukkan nama bank',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                onChanged: (value) {
                  accountNo = value;
                },
                decoration: InputDecoration(
                  hintText: 'Masukkan nomor rekening',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                SharedPreferences pref =
                    await SharedPreferences.getInstance();
                int? userId = pref.getInt('id');
                if (userId != null &&
                    bankName.isNotEmpty &&
                    accountNo.isNotEmpty) {
                  double amount = _balance;
                  try {
                    await ApiSaldo.withdrawBalance(
                        userId, amount, bankName, accountNo);
                    _fetchBalance();
                    _fetchWithdrawHistory();
                  } catch (e) {
                    print('Failed to withdraw balance: $e');
                  }
                } else {
                  print('Invalid user ID, bank name, or account number');
                }
              },
              child: Text('Tarik'),
            ),
          ],
        );
      },
    );
  }
}