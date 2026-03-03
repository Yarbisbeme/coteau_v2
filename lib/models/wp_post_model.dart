class Weather {
  final String cityName;
  final double temperature;
  final double h;
  final double l;
  final String mainCondition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.h,
    required this.l,
    required this.mainCondition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      h:json['main']['temp_max'].toDouble(),
      l:json['main']['temp_min'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}