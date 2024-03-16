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
      name: json['name'],
      capital: json['capital'],
      population: json['population'],
      flag: json['media'] != null ? json['media']['flag'] : null,
      currency: json['currency'],
      phone: json['phone'],
      abbreviation: json['abbreviation'],
      emblem: json['media'] != null ? json['media']['emblem'] : null,
    );
  }
}
