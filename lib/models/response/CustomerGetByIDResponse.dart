// To parse this JSON data, do
//
//     final customerGetByIdResponse = customerGetByIdResponseFromJson(jsonString);

import 'dart:convert';

CustomerGetByIdResponse customerGetByIdResponseFromJson(String str) =>
    CustomerGetByIdResponse.fromJson(json.decode(str));

String customerGetByIdResponseToJson(CustomerGetByIdResponse data) =>
    json.encode(data.toJson());

class CustomerGetByIdResponse {
  int idx;
  String fullname;
  String phone;
  String email;
  String image;

  CustomerGetByIdResponse({
    required this.idx,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
  });

  factory CustomerGetByIdResponse.fromJson(Map<String, dynamic> json) =>
      CustomerGetByIdResponse(
        idx: json["idx"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
      };
}
