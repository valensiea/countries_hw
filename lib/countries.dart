class Country {
  final String? name;
  final String? capital;
  final int? population;
  final String? flag;
  final String? currency;
  final String? phone;
  final String? abbreviation;
  final String? emblem;

  Country({
    required this.name,
    required this.capital,
    required this.population,
    required this.flag,
    required this.currency,
    required this.phone,
    required this.abbreviation,
    required this.emblem,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'] as String?,
      capital: json['capital'] as String?,
      population: json['population'] as int?,
      flag: json['media']?['flag'] as String?,
      currency: json['currency'] as String?,
      phone: json['phone'] as String?,
      abbreviation: json['abbreviation'] as String?,
      emblem: json['media']?['emblem'] as String?,
    );
  }
}
