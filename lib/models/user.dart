import 'dart:convert';

class User {
  int? id;
  String name;
  String? email;
  String username;
  String password;
  String born_date;
  String phone_number;
  int total_point;
  int role_id;

  User({
    this.id,
    required this.name,
    this.email,
    required this.username,
    required this.password,
    required this.born_date,
    required this.phone_number,
    required this.total_point,
    required this.role_id,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        username: json['username'],
        password: json['password'],
        born_date: json['born_date'],
        phone_number: json['phone_number'],
        total_point: json['total_point'],
        role_id: json['role_id'],
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "username": username,
        "password": password,
        "born_date": born_date,
        "phone_number": phone_number,
        "total_point": total_point,
        "role_id": role_id,
      };
}
