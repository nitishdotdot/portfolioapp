import 'package:portfolioapp/data/models/scrip_model.dart';

class UserModel {
  String name;
  String email;
  List<ScripModel> scrip;
  UserModel(this.name, this.email, this.scrip);
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(json['name'], json['email'], makeScrip(json['scrips']));
  }
  static List<ScripModel> makeScrip(List scrip) {
    return scrip.map((x) => ScripModel.fromJson(x)).toList();
  }
}
