# COTEAU ⚙️

### Requerimientos:

- Muestra una foto de una caja de herramientas, ya que esta aplicación sirve para varias cosas.
- Aceptar el nombre de una persona y predecir su genero: (https://api.genderize.io/?name=irma) si es masculino mostraras algo azul, de lo contrario algo rosa en la pantalla.
- Vista que acepte el nombre de una persona y determine la edad de la misma (https://api.agify.io/?name=meelad) dependiendo la edad de la persona debes mostrar un mensaje que diga si es joven, adulto o anciano. Muestra una imagen relativa a cada estado y su edad en numero.
Programa que acepte el nombre de un país en ingles: muestre las universidades de Ese país,  url: https://adamix.net/proxy.php?country=Dominican+Republic , luego mostrar el nombre, dominio y link a pagina web de cada universidad.  
- Clima en RD: La aplicación nos va a mostrar como estará el clima para el dia en que estamos visualizando la tarea.
Aceptar el nombre de un pokemon y mostrar su foto, experiencia base, habilidades y sonido del mismo (latest). https://pokeapi.co/api/v2/pokemon/pikachu
- Una vista donde mostraras el logo de alguna página web hecha con WordPress y luego mostraras el titular y resumen de las últimas 3 noticias publicadas en la misma. Colocar un link visitar donde nos lleva a la noticia original: Ejemplo del api: https://kinsta.com/blog/wordpress-rest-api/, debes publicar el API que usaras en el foro: Foro de las paginas de wordpress
- Agregue una opción acerca de, donde mostraras tu foto y datos de contactos para posibles trabajos. 


## Estructura del proyecto 🦽

```
lib/
│
├── main.dart                  # Punto de entrada de la aplicación
│
├── core/                      # Configuraciones globales
│   ├── constants.dart         # URLs base, paleta de colores (azul/rosa), etc.
│   └── theme.dart             # Tema general de la app
│
├── models/                    # Clases para mapear los JSON de las APIs
│   ├── age_model.dart
│   ├── pokemon_model.dart
│   ├── university_model.dart
│   └── wp_post_model.dart
│
├── services/                  # Lógica para hacer las peticiones HTTP
│   ├── agify_service.dart
│   ├── genderize_service.dart
│   ├── poke_api_service.dart
│   ├── weather_service.dart
│   ├── wp_api_service.dart
│   └── university_service.dart
│
└── ui/                        # Todo lo visual
    ├── screens/               # Las 8 vistas principales de tu requerimiento
    │   ├── home_screen.dart
    │   ├── gender_screen.dart
    │   ├── age_screen.dart
    │   ├── university_screen.dart
    │   ├── weather_screen.dart
    │   ├── pokemon_screen.dart
    │   ├── news_screen.dart
    │   └── about_screen.dart
    │
    └── widgets/               # Componentes reutilizables
        └── custom_drawer.dart # El menú lateral para navegar entre pantallas
```