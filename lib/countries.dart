class Country {
  final String? name;
  final String? capital;
  final int? population;
  final String? flag;

  Country({
    required this.name,
    required this.capital,
    required this.population,
    required this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      capital: json['capital'],
      population: json['population'],
      flag: json['media'] != null ? json['media']['flag'] : null,
    );
  }
}
