import 'dart:io';

import 'package:flutter_login_register/src/model/myuser.dart';

abstract class MyUserRepository {
  String newId();

  Stream<Iterable<MyUser>> getMyUsers();

  Future<void> saveMyUser(MyUser myUser, File? image);

  Future<void> deleteMyUser(MyUser myUser);
}