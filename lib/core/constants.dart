class AppConstants {
  // --- URLs de las APIs ---
  static const String genderizeBaseUrl = 'https://api.genderize.io/';
  static const String agifyBaseUrl = 'https://api.agify.io/';
  static const String universitiesBaseUrl = 'https://adamix.net/proxy.php';
  static const String pokeApiBaseUrl = 'https://pokeapi.co/api/v2/pokemon/';
  // Reemplaza esto con el blog de WordPress que elijas
  static const String wpApiBaseUrl = 'https://techcrunch.com/wp-json/wp/v2/posts'; 

  // --- Rutas de Assets (Imágenes) ---
  static const String toolboxIcon = 'assets/images/toolbox.png';
  static const String youngIcon = 'assets/images/young.png';
  static const String adultIcon = 'assets/images/adult.png';
  static const String elderIcon = 'assets/images/elder.png';
  static const String maleIcon = 'assets/images/male.png';
  static const String femaleIcon = 'assets/images/female.png';
  static const String yarbis = 'assets/images/yarbis.jpg';

  // --- Colores Específicos para la lógica ---
  // Estos los usaremos en la Vista 2 para cambiar el fondo según el género
  static const int colorMaleHex = 0xFF42A5F5; // Azul
  static const int colorFemaleHex = 0xFFEC407A; // Rosa
}