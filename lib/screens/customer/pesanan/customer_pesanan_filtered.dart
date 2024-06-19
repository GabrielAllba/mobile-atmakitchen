import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:atma_kitchen/services/api_pesanan.dart';
import 'package:atma_kitchen/models/transaction.dart';

class CustomerPesananFiltered extends StatefulWidget {
  const CustomerPesananFiltered({Key? key}) : super(key: key);

  @override
  State<CustomerPesananFiltered> createState() => CustomerPesananFilteredState();
}

class CustomerPesananFilteredState extends State<CustomerPesananFiltered> {
  late Future<List<Transaction>> futureTransactions;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureTransactions = ApiService.fetchTransactions();
  }

  void _updateTransactionStatus(Transaction transaction) async {
    try {
      await ApiService.updateTransactionStatus(transaction.id!, "Selesai");

      setState(() {
        futureTransactions = ApiService.fetchTransactions();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction status updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update transaction status')),
      );
    }
  }

  List<Transaction> _searchTransactions(List<Transaction> transactions, String query) {
    if (query.isEmpty) {
      return transactions;
    }

    return transactions.where((transaction) =>
        transaction.invoiceNumber.toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesanan Sedang Dikirim / Sudah di-pickup'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari pesanan',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    // Trigger rebuild on text change
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Transaction>>(
                future: futureTransactions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No transactions found'));
                  } else {
                    List<Transaction> filteredTransactions = _searchTransactions(snapshot.data!, _searchController.text);
                    if (filteredTransactions.isEmpty) {
                      return Center(child: Text('No transactions found with the search criteria'));
                    }
                    return ListView.builder(
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        Transaction transaction = filteredTransactions[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                title: Text('Penerima: ${transaction.namaPenerima}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Invoice: ${transaction.invoiceNumber}'),
                                    Text('Tanggal Pemesanan: ${transaction.tanggalPemesanan}'),
                                    Text('Status: ${transaction.transactionStatus}'),
                                    Text('Jumlah: ${transaction.totalPoinUser.toString()}'),
                                    Text('Total: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(transaction.totalPrice)}'),
                                  ],
                                ),
                                trailing: Icon(
                                  Icons.check_circle,
                                  color: transaction.transactionStatus == 'Selesai' ? Colors.green : Colors.grey,
                                ),
                              ),
                              if (transaction.transactionStatus == 'Sedang dikirim' || transaction.transactionStatus == 'Sudah di-pickup')
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: ElevatedButton(
                                    onPressed: () => _updateTransactionStatus(transaction),
                                    child: Text('Update to Selesai'),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
