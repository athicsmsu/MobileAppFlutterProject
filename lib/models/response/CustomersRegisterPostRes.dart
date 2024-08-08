// To parse this JSON data, do
//
//     final customersRegisterPostRes = customersRegisterPostResFromJson(jsonString);

import 'dart:convert';

CustomersRegisterPostRes customersRegisterPostResFromJson(String str) =>
    CustomersRegisterPostRes.fromJson(json.decode(str));

String customersRegisterPostResToJson(CustomersRegisterPostRes data) =>
    json.encode(data.toJson());

class CustomersRegisterPostRes {
  String message;
  int id;

  CustomersRegisterPostRes({
    required this.message,
    required this.id,
  });

  factory CustomersRegisterPostRes.fromJson(Map<String, dynamic> json) =>
      CustomersRegisterPostRes(
        message: json["message"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "id": id,
      };
}
