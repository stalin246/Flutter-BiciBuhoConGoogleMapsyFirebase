import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_register/main.dart';
import 'package:flutter_login_register/src/model/myuser.dart';
import 'package:flutter_login_register/src/repository/myuserrep.dart';

// Extends Cubit and will emit states of type EditMyUserState
class EditMyUserCubit extends Cubit<EditMyUserState> {
  // Get the injected MyUserRepository
  final MyUserRepository _userRepository = getIt();

  // When we are editing an existing myUser _toEdit won't be null
  MyUser? _toEdit;

  EditMyUserCubit(this._toEdit) : super(const EditMyUserState());

  // This function will be called from the presentation layer
  // when an image is selected
  void setImage(File? imageFile) async {
    emit(state.copyWith(pickedImage: imageFile));
  }

  // This function will be called from the presentation layer
  // when the user has to be saved
  Future<void> saveMyUser(
    String name,
    String lastName,
    int age,
  ) async {
    emit(state.copyWith(isLoading: true));

    // If we are editing, we use the existing id. Otherwise, create a new one.
    final uid = _toEdit?.id ?? _userRepository.newId();
    _toEdit = MyUser(
        id: uid,
        name: name,
        lastName: lastName,
        age: age,
        image: _toEdit?.image);

    await _userRepository.saveMyUser(_toEdit!, state.pickedImage);
    emit(state.copyWith(isDone: true));
  }

  // This function will be called from the presentation layer
  // when we want to delete the user
  Future<void> deleteMyUser() async {
    emit(state.copyWith(isLoading: true));
    if (_toEdit != null) {
      await _userRepository.deleteMyUser(_toEdit!);
    }
    emit(state.copyWith(isDone: true));
  }
}

// Class that will hold the state of this Cubit
// Extending Equatable will help us to compare if two instances
// are the same without override == and hashCode
class EditMyUserState extends Equatable {
  final File? pickedImage;
  final bool isLoading;


  final bool isDone;

  const EditMyUserState({
    this.pickedImage,
    this.isLoading = false,
    this.isDone = false,
  });

  @override
  List<Object?> get props => [pickedImage?.path, isLoading, isDone];

  EditMyUserState copyWith({
    File? pickedImage,
    bool? isLoading,
    bool? isDone,
  }) {
    return EditMyUserState(
      pickedImage: pickedImage ?? this.pickedImage,
      isLoading: isLoading ?? this.isLoading,
      isDone: isDone ?? this.isDone,
    );
  }
}