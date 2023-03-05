import 'dart:io';

import 'package:flutter_login_register/main.dart';
import 'package:flutter_login_register/src/data_source/firebase_data_source.dart';
import 'package:flutter_login_register/src/model/myuser.dart';
import 'package:flutter_login_register/src/repository/myuserrep.dart';

class MyUserRepositoryImp extends MyUserRepository {
  final FirebaseDataSource _fDataSource = getIt();

  @override
  String newId() {
    return _fDataSource.newId();
  }

  @override
  Stream<Iterable<MyUser>> getMyUsers() {
    return _fDataSource.getMyUsers();
  }

  @override
  Future<void> saveMyUser(MyUser myUser, File? image) {
    return _fDataSource.saveMyUser(myUser, image);
  }

  @override
  Future<void> deleteMyUser(MyUser myUser) {
    return _fDataSource.deleteMyUser(myUser);
  }
}