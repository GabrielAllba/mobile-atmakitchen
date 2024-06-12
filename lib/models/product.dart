class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String photo;
  final double stock;
  final double dailyQuota;
  final String status;
  final String tag;
  final int productTypeId;
  final String productType;
  final int? consignationId;
  final String consignation;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.photo,
    required this.stock,
    required this.dailyQuota,
    required this.status,
    required this.tag,
    required this.productTypeId,
    required this.productType,
    this.consignationId,
    required this.consignation,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
      photo: 'http://10.0.2.2:8000/api${json['photo']}', // Change the URL construction
      stock: json['stock'].toDouble(),
      dailyQuota: json['daily_quota'].toDouble(),
      status: json['status'],
      tag: json['tag'],
      productTypeId: json['product_type_id'],
      productType: json['product_type']['name'],
      consignationId: json['consignation_id'],
      consignation: json['consignation']['name'],
    );
  }
}
