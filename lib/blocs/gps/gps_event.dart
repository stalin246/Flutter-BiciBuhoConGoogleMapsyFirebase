part of 'gps_bloc.dart';

abstract class GpsEvent extends Equatable {
  const GpsEvent();

  @override
  List<Object> get props => [];
}

class OnGpsPermissionEvent extends GpsEvent {
  final bool isGpsenabled;
  final bool isGpsPermissionGranted;

  const OnGpsPermissionEvent(
      {required this.isGpsenabled, required this.isGpsPermissionGranted});

  @override
  List<Object> get props => [isGpsenabled, isGpsPermissionGranted];
  @override
  String toString() =>
      'OnGpsPermissionEvent {isGpsenabled: $isGpsenabled, isGpsPermissionGranted: $isGpsPermissionGranted}';
}
