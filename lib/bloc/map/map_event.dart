part of 'map_bloc.dart';

abstract class MapEvent {
  const MapEvent();
}

class MapLoadedEvent extends MapEvent {}

class MapLoadingEvent extends MapEvent {
  List<AtmWithStatus> atms;
  MapLoadingEvent({required this.atms});
}
