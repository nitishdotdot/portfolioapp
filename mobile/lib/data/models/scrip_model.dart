import 'dart:ffi';

class ScripModel {
  String name;
  int kitta;
  String wacc;
  num total;
  num currentProfit;
  String companyName;
  num ltp;
  num invested;
  ScripModel(
    this.name,
    this.kitta,
    this.wacc,
    this.total,
    this.currentProfit,
    this.companyName,
    this.ltp,
    this.invested,
  );
  factory ScripModel.fromJson(Map<String, dynamic> json) {
    return ScripModel(
      json['name'],
      json['kitta'],
      json['wacc'],
      json['total'],
      json['currentProfit'],
      json['companyName'],
      json['ltp'],
      json['invested'],
    );
  }
}
