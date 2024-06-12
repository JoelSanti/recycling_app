# 🌍 Recycling App

Aplicación móvil destinada a mejorar la conciencia ambiental y la gestión de residuos a través del reconocimiento de residuos, mapeo de puntos de reciclaje, cronograma de recolección de residuos y guía de sensibilización.

## 👀 Requisitos

- [Flutter SDK v2.8.1](https://flutter.dev/docs)
- [Dart v2.15.1](https://dart.dev/guides)
- [Firebase Storage v12.0.0](https://firebase.google.com/products/storage)
- [Google Maps Flutter v2.2.8](https://pub.dev/packages/google_maps_flutter)
- [Geolocator v12.0.0](https://pub.dev/packages/geolocator)
- [Get v4.6.6](https://pub.dev/packages/get)
- [Provider v6.1.2](https://pub.dev/packages/provider)
- [Table Calendar v3.1.1](https://pub.dev/packages/table_calendar)
- [Flutter Localization v0.2.0](https://pub.dev/packages/flutter_localizations)
- [Google ML Kit Image Labeling v0.12.0](https://pub.dev/packages/google_mlkit_image_labeling)

## 🤖 Google ML Kit Image Labeling

La aplicación utiliza Google ML Kit Image Labeling para el reconocimiento de residuos. Este paquete permite identificar entidades en una imagen, lo cual es crucial para la funcionalidad de reconocimiento de residuos de la aplicación.

### Mejorando la precisión de la IA

Para mejorar la precisión del reconocimiento de residuos, se pueden seguir los siguientes pasos:

1. **Aumentar la cantidad de datos**: Cuanto más variados y numerosos sean los datos de entrenamiento, mejor será la capacidad del modelo para generalizar y reconocer correctamente los residuos.

2. **Mejorar la calidad de los datos**: Asegúrate de que los datos de entrenamiento sean lo más representativos posible de los datos que el modelo tendrá que manejar en producción. Esto incluye una variedad de tipos de residuos, condiciones de iluminación, ángulos, etc.

3. **Ajustar el modelo**: Experimenta con diferentes arquitecturas de modelos, hiperparámetros, etc. para encontrar la configuración que produce los mejores resultados.

4. **Usar un enfoque de aprendizaje profundo**: Si aún no lo has hecho, considera usar un enfoque de aprendizaje profundo para el reconocimiento de residuos. Los modelos de aprendizaje profundo, como las redes neuronales convolucionales (CNN), han demostrado ser muy eficaces para las tareas de reconocimiento de imágenes.

## 🚀 Cómo empezar

### Configuración del entorno de desarrollo local

1. Clona el repositorio:

```git clone https://github.com/JoelSanti/recycling_app.git

2. Navega al directorio del proyecto:

```cd recycling_app

3. Instala las dependencias:

```flutter pub get

4. Asegúrate de tener un dispositivo emulado (o un dispositivo físico conectado) para ejecutar la aplicación.

5. Ejecuta la aplicación:

```flutter run

### Scripts disponibles

En el directorio del proyecto, puedes ejecutar:

- `flutter run`: Ejecuta la aplicación en modo de desarrollo.
- `flutter build apk --release`: Compila la aplicación para producción en formato APK.
- `flutter test`: Ejecuta la suite de pruebas.