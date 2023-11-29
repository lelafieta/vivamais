import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maxalert/data/repositories/atm_repository.dart';
import 'package:maxalert/models/atm_model.dart';
import 'package:maxalert/utils/app_images.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../models/atm_with_status.dart';

class MapService extends GetxController {
  AtmRepository atmRepo = AtmRepository();

  Set<Marker> markers = {};
  Rx<BitmapDescriptor?> _markerIcon = Rx<BitmapDescriptor?>(null);

  List<Marker> list = [];
  double lat = 0.0;
  double long = 0.0;

  ValueNotifier<String> textPapel = ValueNotifier<String>("");
  ValueNotifier<String> textSlote = ValueNotifier<String>("");
  ValueNotifier<String> textMoney = ValueNotifier<String>("");
  ValueNotifier<String> textEstado = ValueNotifier<String>("");

  ValueNotifier<Color> colorPapel = ValueNotifier<Color>(Colors.black);
  ValueNotifier<Color> colorSlote = ValueNotifier<Color>(Colors.black);
  ValueNotifier<Color> colorMoney = ValueNotifier<Color>(Colors.black);
  ValueNotifier<Color> colorEstado = ValueNotifier<Color>(Colors.black);
  int press = 0;

  String? tipo;

  String? selectedValue;
  LatLng? myLocation;

  late GoogleMapController mapController;
  double _originLatitude = 6.5212402, _originLongitude = 3.3679965;
  double _destLatitude = 6.849660, _destLongitude = 3.648190;
  // double _originLatitude = 26.48424, _originLongitude = 50.04551;
  // double _destLatitude = 26.46423, _destLongitude = 50.06358;

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  String googleAPiKey = "Please provide your api key";

  MapService() {
    getMyLocation();
    _checkLocationPermission();
  }

  getMyLocation() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)),
            AppImages.ATM_ICON_MYLOCATION_MAP)
        .then((icon) {
      _markerIcon.value = icon;
      update();
    });
  }

  Future<void> _checkLocationPermission() async {
    try {
      var status = await Geolocator.requestPermission();

      Position position = await Geolocator.getCurrentPosition();

      myLocation = LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Erro ao obter a localização: $e');
    }
  }

  Future<Set<Marker>> getMarkers(List<AtmWithStatus> atms) async {
    //update();
    // list.add(
    //   Marker(
    //     markerId: MarkerId('minha_localizacao'),
    //     position: myLocation!,
    //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    //     infoWindow: InfoWindow(
    //       title: 'Minha Localização',
    //     ), // Usando o ícone personalizado
    //   ),
    // );

    atms.forEach(
      (element) {
        try {
          lat = double.parse(element.atm.lat.toString());
        } catch (e) {
          lat = 0.0;
        }

        try {
          long = double.parse(element.atm.long.toString());
        } catch (e) {
          long = 0.0;
        }
        list.add(
          Marker(
            markerId: MarkerId("${element.atm.atmSigitCode}"),
            position: LatLng(lat, long),
          ),
        );
      },
    );

    // List<Marker> list = [
    //   Marker(
    //     markerId: MarkerId("Marker 1"),
    //     position: LatLng(-8.9039071, 13.1833099),
    //   ),
    //   Marker(
    //     markerId: MarkerId("Marker 2"),
    //     position: LatLng(-8.9039072, 13.1853990),
    //   ),
    //   Marker(
    //     markerId: MarkerId("Marker 3"),
    //     position: LatLng(-8.9039072, 13.1863990),
    //   ),
    //   Marker(
    //     markerId: MarkerId("Marker 4"),
    //     position: LatLng(-8.9139072, 13.1963990),
    //   ),
    // ];

    print("TAMANHO DA LISTA");
    print(list.length);

    list.forEach(
      (element) async {
        markers.add(
          Marker(
            markerId: element.mapsId,
            position: LatLng(
              element.position.latitude,
              element.position.longitude,
            ),
            icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(),
              AppImages.ATM_ICON_MAP,
            ),
            onTap: () {
              AtmWithStatus atm =
                  atmRepo.getAtmByCode(int.parse(element.mapsId.value), atms);
              if (atm.status.estadoDinheiro == 1) {
                colorMoney.value = Colors.green;
                textMoney.value = "COM DINHEIRO";
              } else if (atm.status.estadoDinheiro == 2) {
                colorMoney.value = Colors.orange;
                textMoney.value = "POUCO DINHEIRO";
              } else {
                colorMoney.value = Colors.red;
                textMoney.value = "SEM DINHEIRO";
              }

              if (atm.status.estadoPapel == 1) {
                colorPapel.value = Colors.green;
                textPapel.value = "COM PAPEL";
              } else if (atm.status.estadoPapel == 2) {
                colorPapel.value = Colors.orange;
                textPapel.value = "POUCO PAPEL";
              } else {
                colorPapel.value = Colors.red;
                textPapel.value = "SEM PAPEL";
              }

              if (atm.status.estadoCartao == 1) {
                colorSlote.value = Colors.green;
                textSlote.value = "OK";
              } else {
                colorSlote.value = Colors.red;
                textSlote.value = "COM PROBLEMA";
              }

              if (atm.status.estado == "S") {
                colorEstado.value = Colors.grey;
                textEstado.value = "MANUTENÇÃO";
              } else {
                if (atm.status.isHorasOffline! > 0) {
                  colorEstado.value = Colors.red;
                  textEstado.value = "OFFLINE";
                } else if (atm.status.isHoraSleeping! > 0) {
                  colorEstado.value = Colors.green;
                  textEstado.value = "DORMINDO";
                } else if (atm.status.isHorasOnline! >= 1) {
                  colorEstado.value = Colors.green;
                  textEstado.value = "ONLINE";
                } else if (atm.status.isHorasOnline! * 60 > 20) {
                  colorEstado.value = Colors.green;
                  textEstado.value = "ONLINE";
                } else {
                  colorEstado.value = Colors.green;
                  textEstado.value = "ONLINE";
                }
              }

              Get.bottomSheet(
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    height: 200,
                    decoration: BoxDecoration(
                      //color: Theme.of(context).colorScheme.background,
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "INFORMAÇÕES DO ATM (${atm.atm.atmSigitCode})",
                              style: GoogleFonts.rajdhani(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: colorPapel.value,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "PAPEL: ",
                                            style: GoogleFonts.rajdhani(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "${textPapel.value}",
                                            style: GoogleFonts.rajdhani(
                                              fontWeight: FontWeight.w900,
                                              color: colorPapel.value,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: colorSlote.value,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "SLOTE CARD: ",
                                            style: GoogleFonts.rajdhani(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "${textSlote.value}",
                                            style: GoogleFonts.rajdhani(
                                              fontWeight: FontWeight.w900,
                                              color: colorSlote.value,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: colorMoney.value,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "DINHEIRO: ",
                                            style: GoogleFonts.rajdhani(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "${textMoney.value}",
                                            style: GoogleFonts.rajdhani(
                                              fontWeight: FontWeight.w900,
                                              color: colorMoney.value,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: colorEstado.value,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "ESTADO: ",
                                            style: GoogleFonts.rajdhani(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "${textEstado.value}",
                                            style: GoogleFonts.rajdhani(
                                              fontWeight: FontWeight.w900,
                                              color: colorEstado.value,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
              // Get.showSnackbar(
              //   GetSnackBar(
              //     title: "oLA",
              //     messageText: Text(
              //         "${atmRepo.getAtmByCode(int.parse(element.mapsId.value), atms).atm.atmSigitCode}"),
              //   ),
              // );
            },
          ),
        );
      },
    );

    print(markers.length);

    update();
    return markers
      ..add(
        Marker(
          markerId: MarkerId('minha_localizacao'),
          position: LatLng(-8.899559, 13.185581),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: 'Minha Localização',
          ), // Usando o ícone personalizado
        ),
      );
  }
}
