class UserEntities {
  String name;
  UserEntities({required this.name});
  factory UserEntities.fromjson(Map<String, dynamic> json) {
    return UserEntities(name: json["name"]);
  }
}
