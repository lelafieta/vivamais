import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maxalert/models/atm_with_status.dart';

abstract class MapState {
  const MapState();
}

class MapInitState extends MapState {}

class MapLoadedState extends MapState {
  Set<Marker> markers = {};
  MapLoadedState(this.markers);
}

class MapErrorState extends MapState {}

class MapLoadingState extends MapState {}
