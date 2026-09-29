class ScripModel {
  String name;
  int kitta;
  int buyprice;
  String buydatetime;
  String? selldatetime;
  int? sellprice;
  double? wacc;
  ScripModel(
    this.name,
    this.kitta,
    this.buydatetime,
    this.buyprice,
    this.selldatetime,
    this.sellprice,
    this.wacc,
  );
  factory ScripModel.fromJson(Map<String, dynamic> json) {
    return ScripModel(
      json['name'],
      json['kitta'],
      json['buydatetime'],
      json['buyprice'],
      json['selldatetime'],
      json['sellprice'],
      json['wacc'],
    );
  }
}
