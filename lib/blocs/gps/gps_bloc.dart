import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? gpsStatusSubscription;

  GpsBloc()
      : super(
            const GpsState(isGpsActive: false, isGpsPermissionGranted: false)) {
    on<OnGpsPermissionEvent>((event, emit) => emit(state.copyWith(
        isGpsActive: event.isGpsenabled,
        isGpsPermissionGranted: event.isGpsPermissionGranted)));

    _init();
  }

  Future<void> _init() async {
  

    final gpsInitstatus = await Future.wait([_checkGpsStatus(), _isPermissionGranted()]);
   

    add(OnGpsPermissionEvent(
        isGpsenabled: gpsInitstatus[0],
        isGpsPermissionGranted: gpsInitstatus[1]));
  }

  Future<bool> _isPermissionGranted() async {
    final isGranted = await Permission.location.isGranted;

    return isGranted;
   
  }

//servicio del GPS
  Future<bool> _checkGpsStatus() async {
    final isEnable = await Geolocator.isLocationServiceEnabled();

    gpsStatusSubscription = Geolocator.getServiceStatusStream().listen((event) {
      // if (status == LocationServiceStatus.disabled) {
      //   onGpsPermissionEvent(false, false);
      // } else {
      //   onGpsPermissionEvent(true, true);
      // }

      final isEnabled = (event.index == 1) ? true : false;
      add(OnGpsPermissionEvent(
          isGpsenabled: isEnabled,
          isGpsPermissionGranted: state.isGpsPermissionGranted));
    });

    return isEnable;
  }

  Future <void> askGpsPermission() async {
    final status = await Permission.location.request();
    switch (status) {
      case PermissionStatus.granted:
        add(OnGpsPermissionEvent(
            isGpsenabled: state.isGpsActive,
            isGpsPermissionGranted: true));
        break;
      case PermissionStatus.denied:
        add(OnGpsPermissionEvent(
            isGpsenabled: state.isGpsActive,
            isGpsPermissionGranted: false));
            openAppSettings();
        break;
      case PermissionStatus.permanentlyDenied:
        add(OnGpsPermissionEvent(
            isGpsenabled: state.isGpsActive,
            isGpsPermissionGranted: false));
            openAppSettings();
        break;
      case PermissionStatus.restricted:
        add(OnGpsPermissionEvent(
            isGpsenabled: state.isGpsActive,
            isGpsPermissionGranted: false));
            openAppSettings();
        break;
      case PermissionStatus.limited:
        add(OnGpsPermissionEvent(
            isGpsenabled: state.isGpsActive,
            isGpsPermissionGranted: false));
            openAppSettings();
        break;
      default:
        add(OnGpsPermissionEvent(
            isGpsenabled: state.isGpsActive,
            isGpsPermissionGranted: false));
            openAppSettings();
        break;
    }
  }
  @override
  Future<void> close() {
    
    gpsStatusSubscription?.cancel();

    return super.close();
  }
}
