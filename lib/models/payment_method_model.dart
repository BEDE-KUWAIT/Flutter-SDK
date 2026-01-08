import 'dart:convert';

class PaymentMethodModel {
  final String id;
  final String name;

  PaymentMethodModel({required this.name, required this.id});

  PaymentMethodModel copyWith({String? name, String? id}) => PaymentMethodModel(name: name ?? this.name, id: id ?? this.id);

  factory PaymentMethodModel.fromRawJson(String str) => PaymentMethodModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) => PaymentMethodModel(name: json["PM_Name"], id: json["PM_CD"]);

  Map<String, dynamic> toJson() => {"PM_Name": name, "PM_CD": id};
}
