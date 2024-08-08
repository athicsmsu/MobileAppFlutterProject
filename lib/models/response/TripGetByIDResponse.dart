// To parse this JSON data, do
//
//     final tripGetByIdResponse = tripGetByIdResponseFromJson(jsonString);

import 'dart:convert';

TripGetByIdResponse tripGetByIdResponseFromJson(String str) =>
    TripGetByIdResponse.fromJson(json.decode(str));

String tripGetByIdResponseToJson(TripGetByIdResponse data) =>
    json.encode(data.toJson());

class TripGetByIdResponse {
  int idx;
  String name;
  String country;
  String coverimage;
  String detail;
  int price;
  int duration;
  String destinationZone;

  TripGetByIdResponse({
    required this.idx,
    required this.name,
    required this.country,
    required this.coverimage,
    required this.detail,
    required this.price,
    required this.duration,
    required this.destinationZone,
  });

  factory TripGetByIdResponse.fromJson(Map<String, dynamic> json) =>
      TripGetByIdResponse(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: json["destination_zone"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "name": name,
        "country": country,
        "coverimage": coverimage,
        "detail": detail,
        "price": price,
        "duration": duration,
        "destination_zone": destinationZone,
      };
}
