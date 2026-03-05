class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final double h; // Tu máxima original
  final double l; // Tu mínima original
  final double maxTemp; 
  final double minTemp; 
  
  // --- NUEVAS VARIABLES PARA EL BENTO GRID ---
  final int humidity;
  final double windSpeed;
  final double feelsLike;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.h,
    required this.l,
    required this.maxTemp,
    required this.minTemp,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
      // Función de ayuda para convertir cualquier valor a double de forma segura
      double parseDouble(dynamic value) {
        if (value == null) return 0.0;
        if (value is double) return value;
        if (value is int) return value.toDouble();
        if (value is String) return double.tryParse(value) ?? 0.0;
        return 0.0;
      }

      return Weather(
        cityName: json['name'] ?? 'Desconocido',
        
        temperature: parseDouble(json['main']['temp']),
        
        mainCondition: (json['weather'] != null && json['weather'].isNotEmpty) 
            ? json['weather'][0]['main'] 
            : 'Desconocido',
            
        h: parseDouble(json['main']['temp_max']),
        l: parseDouble(json['main']['temp_min']),
        maxTemp: parseDouble(json['main']['temp_max']),
        minTemp: parseDouble(json['main']['temp_min']),
        
        // La humedad suele venir como entero
        humidity: (json['main']['humidity'] as num?)?.toInt() ?? 0,
        
        windSpeed: parseDouble(json['wind']?['speed']), // Usamos ? por si 'wind' no existe
        feelsLike: parseDouble(json['main']['feels_like']),
      );
    }
}