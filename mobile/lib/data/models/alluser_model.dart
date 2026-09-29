class AlluserModel {
  String name;
  String email;
  AlluserModel(this.name, this.email);
  factory AlluserModel.fromJson(Map<String, dynamic> json) {
    return AlluserModel(json['name'], json['email']);
  }
}
