class SellScripHistoryModel {
  String name;
  int kitta;
  String selldatetime;
  int sellpice;
  double profit;
  double total;
  SellScripHistoryModel(
    this.name,
    this.kitta,
    this.selldatetime,
    this.sellpice,
    this.profit,
    this.total,
  );
  factory SellScripHistoryModel.fromJson(Map<String, dynamic> json) {
    return SellScripHistoryModel(
      json['name'],
      int.parse(json['kitta'].toString()),
      json['selldatetime'],
      int.parse(json['sellprice'].toString()),
      double.parse(json['profit'].toString()),
      double.parse(json['total'].toString()),
    );
  }
}
