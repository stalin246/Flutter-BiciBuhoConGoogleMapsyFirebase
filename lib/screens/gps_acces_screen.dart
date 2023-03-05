
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_register/blocs/gps/gps_bloc.dart';

class GpsAccesScreen extends StatelessWidget {
  const GpsAccesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          
          return !state.isGpsActive
              ? const _EnableGpsMessage()
              : const _AccesButton();
        },
      ),
    ));
  }
}
// _AccesButton(),

class _AccesButton extends StatelessWidget {
  const _AccesButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Es necesario el acceso al GPS',
        ),
        MaterialButton(
          child: const Text(
            'Acceder al GPS',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          color: Colors.black,
          shape: const StadiumBorder(),
          elevation: 0,
          onPressed: () {
          
          final gpsBloc = BlocProvider.of<GpsBloc>(context);
          gpsBloc.askGpsPermission();


            




          },
        )
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text('Debe tener habilitado el GPS',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ));
  }
}
