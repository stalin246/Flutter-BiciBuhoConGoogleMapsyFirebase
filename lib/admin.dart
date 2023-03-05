import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register/src/repository/auth.dart';
import 'package:flutter_login_register/src/ui/firebase_service.dart';
import 'package:flutter_login_register/src/ui/homeScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login.dart';

class Teacher extends StatefulWidget {
  const Teacher({super.key});

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> get usersStream => _usersRef.snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text("Panel de administración"),
  backgroundColor: Color.fromARGB(255, 204, 220, 233), // define el color de fondo de la AppBar
  actions: [
    IconButton(
      onPressed: () {
        logout(context);
      },
      icon: Icon(
        Icons.logout,
        color: Colors.white, // define el color del ícono
      ),
    )
  ],
),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
              return Card(
                child: ListTile(
                  title: Text(
                    documentSnapshot['email'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    documentSnapshot['rol'],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (documentSnapshot['email'] != _auth.currentUser!.email)
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditUserScreen(
                                  userId: documentSnapshot.id,
                                  email: documentSnapshot['email'],
                                  rol: documentSnapshot['rol'],
                                ),
                              ),
                            );
                          },
                          color: Colors.blue,
                        ),
                      if (documentSnapshot['email'] != _auth.currentUser!.email)
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await firebaseService.deleteUserAccount(
                                documentSnapshot.id, UserUID);
                            Fluttertoast.showToast(msg: 'Usuario eliminado');
                          },
                          color: Colors.red,
                        ),
                      if (documentSnapshot['email'] == _auth.currentUser!.email)
                        IconButton(
                          icon: Icon(Icons.edit_attributes),
                          onPressed: () async {},
                          color: Colors.green,
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
