import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_register/main.dart';
import 'package:flutter_login_register/src/repository/auth.dart';

enum AuthState {
  initial,
  signedOut,
  signedIn,
}

// Extends Cubit and will emit states of type AuthState
class AuthCubit extends Cubit<AuthState> {
  // Get the injected AuthRepository
  final Auth  _authRepository = getIt();
  StreamSubscription? _authSubscription;

  AuthCubit() : super(AuthState.initial);

  Future<void> init() async {
    // Subscribe to listen for changes in the authentication state
    await Future.delayed(const Duration(seconds: 1));
    _authSubscription =
        _authRepository.onAuthStateChanged.listen(_authStateChanged);
  }

  // Helper function that will emit the current authentication state
  void _authStateChanged(String? userUID) {
    userUID == null ? emit(AuthState.signedOut) : emit(AuthState.signedIn);
  }

  // Sign-out and immediately emits signedOut state
  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(AuthState.signedOut);
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}