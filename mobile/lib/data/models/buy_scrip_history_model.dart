class BuyScripHistoryModel {
  String name;
  int kitta;
  String buydatetime;
  int buyprice;
  String total;
  int holding;
  BuyScripHistoryModel(
    this.name,
    this.kitta,
    this.buydatetime,
    this.buyprice,
    this.total,
    this.holding,
  );
  factory BuyScripHistoryModel.fromJson(Map<String, dynamic> json) {
    return BuyScripHistoryModel(
      json['name'],
      int.parse(json['kitta'].toString()),
      json['buydatetime'],
      int.parse(json['buyprice'].toString()),
      json['total'],
      json['holding'],
    );
  }
}
