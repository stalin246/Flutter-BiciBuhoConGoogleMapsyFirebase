import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_register/admin.dart';
import 'package:flutter_login_register/screens/screens.dart';

import 'package:flutter_login_register/src/cubits/authCubits.dart';
import 'package:flutter_login_register/src/cubits/homeCubit.dart';
import 'package:flutter_login_register/src/model/myuser.dart';
import 'package:flutter_login_register/src/ui/widgets/customImage.dart';
import 'package:flutter_login_register/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';


import '../navigation/routes.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
User? _currentUser = _auth.currentUser;
String? _currentUserRol;

    return MaterialApp(
      title: 'Lista de usuarios registrados',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListScreen(),
    );
  }
  
}


class UserListScreen extends StatelessWidget {
  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');
      

  Stream<QuerySnapshot> get usersStream => _usersRef.snapshots();

  Future<void> signOut() async {
    await _auth.signOut();
  }
  
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Lista de usuarios registrados'),
      backgroundColor: Color.fromARGB(255, 193, 215, 233), // define el color de fondo de la AppBar
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            await signOut();
          },
        ),
      ],
    ),
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
    );
  },
);

      },
    ),
    
    floatingActionButton: Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoadingScreen(),
                  ),
                );
              },
              child: const Icon(Icons.map),
            ),
          ),
        ),
        Positioned(
          bottom: 80.0,
          left: 0, 
          right: 0,
          child: const Text(
            'Ver el mapa.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    ),

    bottomNavigationBar: BottomAppBar(
  color: Colors.white,
  child: Container(
    height: 50.0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_auth.currentUser!.email == 'epfarinango@gmail.com' || _auth.currentUser!.email == 'stalinvalencia24@gmail.com')
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Teacher(),
                ),
              );
            },
            child: const Text(
              'Administrar usuarios',
              style: TextStyle(color: Colors.blue, fontSize: 18.0),
            ),
          ),
      ],
    ),
  ),
),


  );
}

  
}


Future<String?> _currentUserRol() async {
  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');
  User? _currentUser = _auth.currentUser;
  String? _currentUserRol;
  _currentUserRol = await firebaseService.getUserRol(_currentUser!.uid);
  print(_currentUserRol);
  return _currentUserRol;

}





class EditUserScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String rol;

  const EditUserScreen({
    Key? key,
    required this.userId,
    required this.email,
    required this.rol,
  }) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _rolController = TextEditingController();
  final _controller = StreamController<List<String>>();
  late Timer _timer;

  @override
  void initState() {


    super.initState();
    _emailController.text = widget.email;
    _rolController.text = widget.rol;
    _timer = Timer.periodic(Duration(seconds:5), (timer) async {
      final users = await FirebaseService().getUsers();
      _controller.add(users.cast<String>());
    }
);

  }



 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar usuario'),
         backgroundColor: Color.fromARGB(255, 204, 220, 233), 
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                contentPadding: EdgeInsets.all(10),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Debe ingresar el Email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _rolController,
              decoration: InputDecoration(
                labelText: 'Rol',
                contentPadding: EdgeInsets.all(10),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Debe ingresar el Rol';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await FirebaseService().updateUser(
                    widget.userId,
                    _emailController.text,
                    _rolController.text,
                  );
                  Fluttertoast.showToast(msg: 'Usuario actualizado');
                  Navigator.pop(context);
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}



