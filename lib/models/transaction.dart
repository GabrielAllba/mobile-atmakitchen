import 'dart:convert';
import 'user.dart';

class Transaction {
  int id;
  String invoiceNumber;
  int userId;
  User user;
  String lunasPada;
  String tanggalPemesanan;
  String namaPenerima;
  String alamatPenerima;
  String noTelpPenerima;
  String delivery;
  String transactionStatus;
  double distance;
  double deliveryFee;
  double totalPrice;
  double transferNominal;
  double pointUsed;
  double pointIncome;
  String paymentDate;
  String paymentProof;
  double totalPoinUser;
  double userTransfer;
  double tips;

  Transaction({
    required this.id,
    required this.invoiceNumber,
    required this.userId,
    required this.user,
    required this.lunasPada,
    required this.tanggalPemesanan,
    required this.namaPenerima,
    required this.alamatPenerima,
    required this.noTelpPenerima,
    required this.delivery,
    required this.transactionStatus,
    required this.distance,
    required this.deliveryFee,
    required this.totalPrice,
    required this.transferNominal,
    required this.pointUsed,
    required this.pointIncome,
    required this.paymentDate,
    required this.paymentProof,
    required this.totalPoinUser,
    required this.userTransfer,
    required this.tips,
  });

  factory Transaction.fromRawJson(String str) => Transaction.fromJson(json.decode(str));

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        invoiceNumber: json['invoice_number'],
        userId: json['user_id'],
        user: User.fromJson(json['user']),
        lunasPada: json['lunas_pada'],
        tanggalPemesanan: json['tanggal_pemesanan'],
        namaPenerima: json['nama_penerima'],
        alamatPenerima: json['alamat_penerima'],
        noTelpPenerima: json['no_telp_penerima'],
        delivery: json['delivery'],
        transactionStatus: json['transaction_status'],
        distance: json['distance'].toDouble(),
        deliveryFee: json['delivery_fee'].toDouble(),
        totalPrice: json['total_price'].toDouble(),
        transferNominal: json['transfer_nominal'].toDouble(),
        pointUsed: json['point_used'].toDouble(),
        pointIncome: json['point_income'].toDouble(),
        paymentDate: json['payment_date'],
        paymentProof: json['payment_proof'],
        totalPoinUser: json['total_poin_user'].toDouble(),
        userTransfer: json['user_transfer'].toDouble(),
        tips: json['tips'].toDouble(),
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'id': id,
        'invoice_number': invoiceNumber,
        'user_id': userId,
        'user': user.toJson(),
        'lunas_pada': lunasPada,
        'tanggal_pemesanan': tanggalPemesanan,
        'nama_penerima': namaPenerima,
        'alamat_penerima': alamatPenerima,
        'no_telp_penerima': noTelpPenerima,
        'delivery': delivery,
        'transaction_status': transactionStatus,
        'distance': distance,
        'delivery_fee': deliveryFee,
        'total_price': totalPrice,
        'transfer_nominal': transferNominal,
        'point_used': pointUsed,
        'point_income': pointIncome,
        'payment_date': paymentDate,
        'payment_proof': paymentProof,
        'total_poin_user': totalPoinUser,
        'user_transfer': userTransfer,
        'tips': tips,
      };
}
