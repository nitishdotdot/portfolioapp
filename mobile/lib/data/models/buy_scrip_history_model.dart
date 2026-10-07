class BuyScripHistoryModel {
  String name;
  int kitta;
  String buydatetime;
  int buyprice;
  BuyScripHistoryModel(this.name, this.kitta, this.buydatetime, this.buyprice);
  factory BuyScripHistoryModel.fromJson(Map<String, dynamic> json) {
    return BuyScripHistoryModel(
      json['name'],
      int.parse(json['kitta'].toString()),
      json['buydatetime'],
      int.parse(json['buyprice'].toString()),
    );
  }
}
