# Aplicación de geolocalización a tiempo real "BiciBúho"

### Integrantes: 
- Eduardo Farinango
- Luis Valencia

# Configuración del poyecto
## Firebase 


Para configurar los servicios que utilizaremos de Firebase en el proyecto nos dirigimos en la sección del archivo [pubspec.yaml](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/pubspec.yaml) y podemos agregar o instalar las dependencias de Firebase que será la autenticación, core de Firebase y colecciones .


```
firebase_auth: ^4.2.9
firebase_core: ^2.7.0
cloud_firestore: ^4.4.3
```
Antes de que se pueda usar cualquiera de los servicios de Firebase, se debe inicializar FlutterFire, puede obtener más información sobre Firebase CLI en la [documentación](https://firebase.google.com/docs/cli)


Se activa el Fluter Cli en el proyecto con el comando: 

```
dart pub global activate flutterfire_cli
```
Creamos un proyecto en Firebase y elegimos que las reglas tanto del manejo de colecciones y base de datos a tiempo real estén en modo de prueba y la autenticación sea posible por correo electrónico.

Se escoge y configura al proyecto de Firebase que se va a conectar nuestra aplicación en Flutter que en este caso será para iOS, web y principalmente Android
```
flutterfire configure
```
![image](https://user-images.githubusercontent.com/77359338/222984102-1b0c2ad3-e9eb-4a32-a23c-4ba00c9a13a6.png)

## Inicialización

Importamos la librería en la siguiente ruta: 
```
lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
```
Dentro de la función main, asegúrese de que WidgetsFlutterBinding esté inicializado y luego inicialice Firebase
```
lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


```

Realizando este proceso, la aplicación se conecta con Firebase y se crea un archivo respectivamente, relacionando la conexión [firebase_options.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/firebase_options.dart)


## Google Maps 

Para usar los servicios de Google Maps se debe agregar/instalar la siguiente dependencia en el archivo [pubspec.yaml](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/pubspec.yaml) 

```
google_maps_flutter: ^2.2.5

```
**Aviso⚠️:** Se debe contar con el **MapSDK para Android** ofrecido por la API de Google Maps y servicios para emplear el Apikey en el archivo [AndroidManifest.xml](https://github.com/stalin246/Flutter-GeolocalizacionConGoogleMaps/blob/v1.1/android/app/src/main/AndroidManifest.xml)

```
<meta-data 
        android:name="com.google.android.geo.API_KEY"
        android:value="aquí va la apikey "
/>
```




Para configuras los se
This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
