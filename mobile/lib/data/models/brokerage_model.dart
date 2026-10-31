class BrokerageModel {
  String sebComm;
  String brComm;
  int dpCharge;
  String shortTax;
  String longTax;

  BrokerageModel(
    this.sebComm,
    this.brComm,
    this.dpCharge,
    this.shortTax,
    this.longTax,
  );
  factory BrokerageModel.fromJson(Map<String, dynamic> json) {
    return BrokerageModel(
      json['sebComm'],
      json['brComm'],
      json['dpCharge'],
      json['shortTax'],
      json['longTax'],
    );
  }
}
