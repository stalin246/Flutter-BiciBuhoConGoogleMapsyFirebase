part of 'gps_bloc.dart';

class GpsState extends Equatable {
  
  final bool isGpsActive;
  final bool isGpsPermissionGranted;

  bool get isAllGranted => isGpsActive && isGpsPermissionGranted;

  








  const GpsState({
    required this.isGpsActive, 
    required this.isGpsPermissionGranted
    });

  GpsState copyWith({
    bool? isGpsActive,
    bool? isGpsPermissionGranted,
  }) {
    return GpsState(
      isGpsActive: isGpsActive ?? this.isGpsActive,
      isGpsPermissionGranted: isGpsPermissionGranted ?? this.isGpsPermissionGranted,
    );
  }
  
  @override
  List<Object> get props => [isGpsActive, isGpsPermissionGranted];
  @override 
  String toString() => 'GpsState {isGpsActive: $isGpsActive, isGpsPermissionGranted: $isGpsPermissionGranted}';

}





