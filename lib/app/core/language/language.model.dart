class LanguageModel {
  const LanguageModel({
    required this.name,
    required this.code,
    required this.icon,
  });

  final String name;
  final String code;
  final String icon;

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
        name: json['name'], code: json['code'], icon: json['icon']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'code': code, 'icon': icon};
  }
}
