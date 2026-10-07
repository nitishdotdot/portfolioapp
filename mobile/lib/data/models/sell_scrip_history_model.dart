class SellScripHistoryModel {
  String name;
  int kitta;
  String selldatetime;
  int sellpice;
  SellScripHistoryModel(
    this.name,
    this.kitta,
    this.selldatetime,
    this.sellpice,
  );
  factory SellScripHistoryModel.fromJson(Map<String, dynamic> json) {
    return SellScripHistoryModel(
      json['name'],
      int.parse(json['kitta'].toString()),
      json['selldatetime'],
      int.parse(json['sellprice'].toString()),
    );
  }
}
