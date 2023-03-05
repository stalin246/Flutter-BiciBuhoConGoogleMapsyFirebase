import 'package:flutter_login_register/blocs/blocs.dart';
import 'package:flutter_login_register/screens/gps_acces_screen.dart';
import 'package:flutter_login_register/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          return state.isAllGranted
              ?  const MapScreen()
              : const GpsAccesScreen();
        },
      ),
      
    );
  }
}
