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

## Funcionalidad del código en el Proyecto de Flutter
Para realizar la funcionalidad que va a tener el mapa una vez que el usuario/ciclista se registre y se dé click en el icono de mapa, la aplicación ahí debe solicitar permisos para que pueda utilizar la funcionalidad de GPS dentro del dispositivo móvil, para ello creamos una carpeta [gps](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/tree/master/lib/blocs/gps)
que alojara la parte lógica para solicitar estos permisos para que finalmente el archivo  [gps_bloc.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/blocs/gps/gps_bloc.dart)
 contenga la función global del GPS y sea utilizado más adelante. 
 Definido los permisos podemos utilizar esa parte logica para mostrar en el dispositivo mediante el codigo que encontramos en el archivo  [gps_acces_screen.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/screens/gps_acces_screen.dart)

Ya configurado los apikey de gooole Maps, en la carpeta  [screens](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/tree/master/lib/screens) y archivo  [map_screen.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/screens/map_screen.dart) trabajamos con la lógica y la parte ui que tendrá el mapa y definimos las propiedades principales que se utilizaran que en este caso será la ubicación a tiempo real en el mapa de Google del usuario logueado, marcadores a tiempo real para cada usuario/ciclistas y que esta información se actualice en Firestore según se cambie la ubicación en donde se creara una colección denominada **userLocations** con campo y valor(location y timestamp) y esta colección estará asociada su ID con el **nombre del correo** que está alojada como campo en otra colección que es la principal denominada **users**, finalmente en el archivo  [loading_screen.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/screens/loading_screen.dart) se crea una clase que englobe la pantalla de habilitacion de GPS y el mapa. Mediante este proceso se puede mostrar las ubicaciones en el mapa de Google a través de marcadores del usuario/ciclista registrado una vez que ellos inicialicen esa función que se encuentra en el archivo [homeScreen.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/src/ui/homeScreen.dart) como botón flotante de **mapa**


