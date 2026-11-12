class AboutUserModel {
  String name;
  String email;
  String phone;
  String address;
  String memberSince;
  String boid;
  String photoUrl;
  AboutUserModel(
    this.name,
    this.email,
    this.phone,
    this.address,
    this.memberSince,
    this.boid,
    this.photoUrl,
  );
  factory AboutUserModel.fromJson(Map<String, dynamic> json) {
    return AboutUserModel(
      json['name'],
      json['email'],
      json['phone'] ?? '9800000000',
      json['address'] ?? '',
      json['MemberSince'] ?? DateTime.now().toUtc().toIso8601String(),
      json['Boid'] ?? '',
      json['photoUrl'] ?? '',
    );
  }
}
