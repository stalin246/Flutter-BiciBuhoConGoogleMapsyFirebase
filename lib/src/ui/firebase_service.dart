import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> getUsers() async {
    QuerySnapshot querySnapshot = await firestore.collection('users').get();
    return querySnapshot.docs;
  }

  Future<void> addUser(String email, String rol) async {
    await firestore.collection('users').add({
      'email': email,
      'rol': rol,
    });
  }

  Future<void> updateUser(String id, String email, String rol) async {
    await firestore.collection('users').doc(id).update({
      'email': email,
      'rol': rol,
    });
  }
//******************************************************************************** */
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


  getUserRol(String uid) {
    return firestore.collection('users').doc(uid).get();
    



  }
}

