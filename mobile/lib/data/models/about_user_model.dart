class AboutUserModel {
  String name;
  String email;
  AboutUserModel(this.name, this.email);
  factory AboutUserModel.fromJson(Map<String, dynamic> json) {
    return AboutUserModel(json['name'], json['email']);
  }
}
