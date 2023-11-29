import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maxalert/bloc/map/map_state.dart';
import 'package:maxalert/data/services/map_service.dart';
import 'package:maxalert/models/atm_with_status.dart';

part 'map_event.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final mapService = MapService();

  final secureStorage = FlutterSecureStorage();

  MapBloc() : super(MapInitState()) {
    on<MapLoadingEvent>((event, emit) async {
      emit(MapLoadingState());

      Set<Marker> markers = await mapService.getMarkers(event.atms);

      if (event.atms != {}) {
        emit(MapLoadedState(markers));
      } else {
        emit(MapErrorState());
      }
    });
  }
}
