class ScripModel {
  String name;
  int kitta;
  String wacc;
  String total;
  ScripModel(this.name, this.kitta, this.wacc, this.total);
  factory ScripModel.fromJson(Map<String, dynamic> json) {
    return ScripModel(json['name'], json['kitta'], json['wacc'], json['total']);
  }
}
