import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_register/src/app.dart';
import 'firebase_options.dart';


import 'package:flutter_login_register/src/cubits/authCubits.dart';
import 'package:flutter_login_register/src/data_source/firebase_data_source.dart';
import 'package:flutter_login_register/src/repository/auth.dart';
import 'package:flutter_login_register/src/repository/implementation/authIm.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_login_register/src/repository/implementation/myuserimp.dart';
import 'package:flutter_login_register/src/repository/myuserrep.dart';
import 'blocs/gps/gps_bloc.dart';
import 'package:geolocator/geolocator.dart';


import 'package:cloud_firestore/cloud_firestore.dart';



final getIt = GetIt.instance;
void main() async {
  

  WidgetsFlutterBinding.ensureInitialized();
  

  //Inicializamos con firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await injeDependencies();

  runApp(
  
      
     

      BlocProvider(
        create: (_) => AuthCubit()..init(),
        child: BlocProvider(
          create: (context) => GpsBloc(),
          child: const MyApp(),
        ),
     
        
        
     
    
  )
  
  );
}

Future<void> injeDependencies() async {
  
  getIt.registerLazySingleton(() => FirebaseDataSource());
  getIt.registerLazySingleton<Auth>(() => AuthImp());
  getIt.registerLazySingleton<MyUserRepository>(() => MyUserRepositoryImp());
}






