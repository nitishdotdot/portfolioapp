import 'dart:ffi';

class ScripModel {
  String name;
  int kitta;
  String wacc;
  String total;
  double currentProfit;
  String companyName;
  num ltp;
  ScripModel(
    this.name,
    this.kitta,
    this.wacc,
    this.total,
    this.currentProfit,
    this.companyName,
    this.ltp,
  );
  factory ScripModel.fromJson(Map<String, dynamic> json) {
    return ScripModel(
      json['name'],
      json['kitta'],
      json['wacc'],
      json['total'],
      json['currentProfit'],
      json['company_name'],
      json['ltp'],
    );
  }
}
