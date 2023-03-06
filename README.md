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

### Inicio de sesión y registro
Para el inicio de sesión se utiliza la autenticación de Firebase importando **firebase_auth.dart** y **cloud_firestore.dart** para la colección denominada "Users"que almacenará el mail y rol que tendrá en su defecto el ciclista. 

En el registro definimos condiciones que se tendrá al iniciar sesión y se lo hará por correo y contraseña y que una vez registrado pase directo a la pantalla del home dependiendo si es Admin o User. La lógica la encontramos en los archivos [login.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/register.dart) y [gps_acces_screen.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/register.dart)

Establecido el login y registro podremos poner un splash screen que funcione al iniciar la aplicación y una pantalla deslizable que nos direcciones al login, la lógica del splash lo vemos aquí [splashScreen.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/src/ui/splashScreen.dart) y lo utilizamos en la ruta que definimos en [routes.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/src/navigation/routes.dart), además para la otra función que se mencionó creamos un archivo [startScreen.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/src/ui/startScreen.dart) y su clase invocara al **login.dart**. Esta clase se la utiliza en las rutas de antes.

#### Funcionamiento en el móvil




### Lista de usuarios(Usuario Común)
Una vez que un usuario/ciclista haya iniciado sesión en su aplicación de Flutter y haya autenticado sus credenciales con Firebase, podrá acceder a la base de datos de Firestore para recuperar una lista de usuarios registrados en la colección correspondiente. Para ello, se puede utilizar un StreamBuilder que escuche los cambios en la colección y muestre los datos actualizados en la interfaz de usuario de la aplicación como se observa en la estructura del documento [homeScreen.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/src/ui/homeScreen.dart)

```sh

Stream<QuerySnapshot> get usersStream => _usersRef.snapshots();
body: StreamBuilder<QuerySnapshot>(
      stream: usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return ListView.builder(
  itemCount: snapshot.data!.docs.length,
  itemBuilder: (context, index) {
    DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
    return ListTileTheme(
      selectedColor: Colors.blue, // cambiar el color de fondo cuando se selecciona un elemento
      child: ListTile(
        title: Text(
          documentSnapshot['email'],
          style: TextStyle(
            fontWeight: FontWeight.bold, // cambiar el estilo de texto del título
            fontSize: 16.0,
          ),
        ),
        subtitle: Text(
          documentSnapshot['rol'],
          style: TextStyle(
            color: Colors.grey, // cambiar el color de texto del subtítulo
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
        ),
      ),
```
Aqui tambien se muestra una implementación básica de un ListView.builder que utiliza una instancia de QuerySnapshot para obtener una lista de documentos de usuarios desde Firestore y muestra los datos en la interfaz de usuario de la aplicación.



<img src="https://user-images.githubusercontent.com/75056800/223001741-fea6a499-5f03-4f62-9463-9fd381f21ce3.jpeg" alt="listUsers" width="200" style="display: block; margin: 0 auto;">


### Gestión de usuarios(Usuario Admin CRUD)
El archivo [firebase_service.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/src/ui/firebase_service.dart) es un archivo que contiene una clase "FirebaseService" que se utiliza para interactuar con Firebase y gestionar la información de los usuarios. La clase FirebaseService tiene los siguientes métodos:

getUser: 
El método devuelve una lista de documentos (DocumentSnapshot) que representan los documentos en la colección 'users'. Estos documentos contienen la información de cada usuario registrado en la aplicación, como correo electrónico y el rol.

```sh
 Future<List<DocumentSnapshot>> getUsers() async {
    QuerySnapshot querySnapshot = await firestore.collection('users').get();
    return querySnapshot.docs;
  }

```

addUser:
Este método se utiliza para agregar un nuevo usuario a la colección 'users' en Firebase Firestore. El nuevo usuario se representa mediante un nuevo documento que contiene su correo electrónico y rol.

```sh
 Future<void> addUser(String email, String rol) async {
    await firestore.collection('users').add({
      'email': email,
      'rol': rol,
    });
  }
```
updateUser:
Este método e utiliza para actualizar la información de un usuario existente en la colección 'users' en Firebase Firestore. El usuario se representa mediante un documento específico que se identifica por su identificador único (id) y se actualiza con el nuevo correo electrónico y rol proporcionados (email y rol).

```sh
 Future<void> updateUser(String id, String email, String rol) async {
    await firestore.collection('users').doc(id).update({
      'email': email,
      'rol': rol,
    });
  }

```
deleteUser:
Este método e utiliza para eliminar la cuenta de un usuario registrado en la aplicación y todos sus documentos relacionados en la colección 'usersLocations'. El método utiliza una transacción de lote para eliminar los documentos de forma segura y cierra la sesión del usuario eliminado después de la eliminación exitosa.


```sh
Future<void> deleteUserAccount(String uid, Type userUID) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null && user.uid == uid) {
    // Si se intenta eliminar la cuenta del usuario actual, mostrar un mensaje de error
    Fluttertoast.showToast(msg: 'No puedes eliminar tu propia cuenta');
    return;
  }
  final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
  final userDoc = await userRef.get();
  if (!userDoc.exists) {
    Fluttertoast.showToast(msg: 'El usuario no existe');
    return;
  }
  final batch = FirebaseFirestore.instance.batch();
  // Eliminar el usuario y todos sus documentos relacionados
  batch.delete(userRef);
  final docsToDelete = await FirebaseFirestore.instance
      .collection('usersLocations')
      .where('email', isEqualTo: userDoc.get('email'))
      .get();
  for (final doc in docsToDelete.docs) {
    batch.delete(doc.reference);
  }
  await batch.commit();
  
  // Cerrar la sesión del usuario eliminado
  await FirebaseAuth.instance.signOut();
  
  Fluttertoast.showToast(msg: 'Usuario eliminado');
}
```



### Geolocalización con Mapa de Google
Para realizar la funcionalidad que va a tener el mapa una vez que el usuario/ciclista se registre y se dé click en el icono de mapa, la aplicación ahí debe solicitar permisos para que pueda utilizar la funcionalidad de GPS dentro del dispositivo móvil, para ello creamos una carpeta [gps](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/tree/master/lib/blocs/gps)
que alojara la parte lógica para solicitar estos permisos para que finalmente el archivo  [gps_bloc.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/blocs/gps/gps_bloc.dart)
 contenga la función global del GPS y sea utilizado más adelante. 
 Definido los permisos podemos utilizar esa parte logica para mostrar en el dispositivo mediante el codigo que encontramos en el archivo  [gps_acces_screen.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/screens/gps_acces_screen.dart)

Ya configurado los apikey de gooole Maps, en la carpeta  [screens](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/tree/master/lib/screens) y archivo  [map_screen.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/screens/map_screen.dart) trabajamos con la lógica y la parte ui que tendrá el mapa y definimos las propiedades principales que se utilizaran que en este caso será la ubicación a tiempo real en el mapa de Google del usuario logueado, marcadores a tiempo real para cada usuario/ciclistas y que esta información se actualice en Firestore según se cambie la ubicación en donde se creara una colección denominada **userLocations** con campo y valor(location y timestamp) y esta colección estará asociada su ID con el **nombre del correo** que está alojada como campo en otra colección que es la principal denominada **users**, finalmente en el archivo  [loading_screen.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/screens/loading_screen.dart) se crea una clase que englobe la pantalla de habilitacion de GPS y el mapa. Mediante este proceso se puede mostrar las ubicaciones en el mapa de Google a través de marcadores del usuario/ciclista registrado una vez que ellos inicialicen esa función que se encuentra en el archivo [homeScreen.dart](https://github.com/stalin246/Flutter-BiciBuhoconGoogleMapsyFirebase/blob/master/lib/src/ui/homeScreen.dart) como botón flotante de **mapa**


