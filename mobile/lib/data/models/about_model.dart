/// One highlighted feature of the app (shown as a row on the About page).
class AboutFeature {
  const AboutFeature({required this.title, required this.description});

  final String title;
  final String description;

  factory AboutFeature.fromJson(Map<String, dynamic> json) => AboutFeature(
    title: '${json['title'] ?? ''}',
    description: '${json['description'] ?? ''}',
  );
}

/// Response of GET /about
class AboutModel {
  const AboutModel({
    required this.id,
    required this.appName,
    required this.version,
    required this.tagline,
    required this.description,
    required this.developerName,
    required this.supportEmail,
    required this.website,
    required this.disclaimer,
    required this.features,
  });

  final int id;
  final String appName;
  final String version;
  final String tagline;
  final String description;
  final String developerName;
  final String supportEmail;
  final String website;
  final String disclaimer;
  final List<AboutFeature> features;

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    final rawFeatures = json['features'];
    return AboutModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      appName: '${json['appName'] ?? ''}',
      version: '${json['version'] ?? ''}',
      tagline: '${json['tagline'] ?? ''}',
      description: '${json['description'] ?? ''}',
      developerName: '${json['developerName'] ?? ''}',
      supportEmail: '${json['supportEmail'] ?? ''}',
      website: '${json['website'] ?? ''}',
      disclaimer: '${json['disclaimer'] ?? ''}',
      features: rawFeatures is List
          ? rawFeatures
                .whereType<Map<String, dynamic>>()
                .map(AboutFeature.fromJson)
                .toList()
          : const [],
    );
  }
}
