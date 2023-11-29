import 'dart:async';
import 'dart:io';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_selector/widget/flutter_single_select.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:maxalert/bloc/atm/atm_bloc.dart';
import 'package:maxalert/bloc/atm/atm_state.dart';
import 'package:maxalert/bloc/map/map_bloc.dart';
import 'package:maxalert/bloc/map/map_state.dart';
import 'package:maxalert/data/repositories/atm_repository.dart';
import 'package:maxalert/data/services/map_service.dart';
import 'package:maxalert/models/atm_with_status.dart';
import 'package:maxalert/presentation/screens/atm/atm_details_screen.dart';
import 'package:maxalert/presentation/screens/atm/widget/atm_reload_component.dart';
import 'package:maxalert/presentation/screens/atm/widget/atm_widget.dart';
import 'package:maxalert/presentation/screens/atm/widget/atm_widget_skeleton.dart';
import 'package:maxalert/presentation/screens/login_screen.dart';

import 'package:maxalert/utils/app_colors.dart';
import 'package:maxalert/utils/app_constants.dart';
import 'package:maxalert/utils/app_icons.dart';
import 'package:maxalert/utils/app_images.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  ValueNotifier<String> _deviceID = ValueNotifier<String>("");
  String? _mapStyle;

  final _mapService = Get.put(MapService());
  final bloc = MapBloc();
  String mapTheme = '';
  GoogleMapController? mapController;

  final ScrollController _controller = ScrollController();
  bool _showEndOfListMessage = false;

  ValueNotifier<int> count = ValueNotifier<int>(0);
  ScrollController _semicircleController = ScrollController();
  String? storageTheme;

  int contador = 0;

  final List<String> items = [
    'TODOS',
    'BALCÃO',
    'CENTER',
    'REMOTO',
  ];

  String selectedValue = "TODOS";
  int controlSearch = 0;
  FlutterSecureStorage storage = FlutterSecureStorage();

  final AtmRepository _atmRepository = AtmRepository();

  late AtmBloc blocAtm;
  Rx<List<AtmWithStatus>> atms = Rx<List<AtmWithStatus>>([]);
  int _searchIndex = 0;
  bool control = false;
  String query = "";
  bool controleState = false;
  BitmapDescriptor? _markerIcon;

  @override
  void initState() {
    super.initState();
    controleState = true;
    getTheme();
    _initLocationStream();
    DefaultAssetBundle.of(context)
        .loadString(AppConstants.MAP_CONFIG)
        .then((value) {
      mapTheme = value;
    }).catchError((error) {
      print("ERROR ${error}");
    });
    rootBundle.loadString("assets/map_config.json").then((string) {
      _mapStyle = string;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)),
            'assets/images/sua_imagem.png')
        .then((icon) {
      setState(() {
        _markerIcon = icon;
      });
    });

    blocAtm = AtmBloc(atmRepository: _atmRepository);
    blocAtm.add(AtmLoadingEvent());
  }

  TextEditingController _query = TextEditingController();

  void getTheme() async {
    storageTheme = await storage.read(key: "theme_preference");
  }

  Future<void> _setMapStyle() async {
    String style = await DefaultAssetBundle.of(context)
        .loadString(AppConstants.MAP_CONFIG);
    mapController!.setMapStyle(style);
  }

  void _initLocationStream() async {
    var status = await Geolocator.requestPermission();
    if (_deviceID.value != "" && status != LocationPermission.deniedForever) {
      Geolocator.getPositionStream().listen((Position position) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapLoadingState) {
            return Center(
              child: Center(child: Text("Carregando...")),
            );
          } else if (state is MapLoadedState) {
            print("object");
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    padding:
                        EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 8),
                    child: Stack(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding:
                                      EdgeInsets.only(left: 10, right: 120),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceTint
                                          .withOpacity(.5),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .shadow
                                            .withOpacity(.2),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: _query,
                                    style: GoogleFonts.rajdhani(
                                      fontWeight: FontWeight.w900,
                                    ),
                                    onChanged: (value) {
                                      query = value;
                                      blocAtm.add(AtmSearchEvent(
                                          atms: atms.value,
                                          query: value,
                                          type: controlSearch,
                                          indexSearch: _searchIndex));
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Pesquisar...",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 11.0,
                                      ), // Reduza o espaçamento vertical
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 3,
                          top: 3,
                          child: Container(
                            height: 34,
                            width: 110,
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: AppColors.MAIN_BACKGROUND,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomSingleSelectField<Object>(
                                    items: items,
                                    title: "TIPOS DE ATM",
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      suffixIcon: Row(
                                        children: [
                                          Container(
                                            width: 70,
                                            child: Text(
                                              "${items.elementAt(controlSearch)}",
                                              style: GoogleFonts.racingSansOne(
                                                fontSize: 18,
                                                color: AppColors.SECOND_COLOR,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            color: AppColors.SECOND_COLOR,
                                            Icons.arrow_forward_ios_rounded,
                                          )
                                        ],
                                      ),
                                      labelStyle: GoogleFonts.rajdhani(
                                        fontSize: 8,
                                        color: Colors.red,
                                      ),
                                      suffixIconColor: Colors.white,
                                      focusColor: Colors.white,
                                    ),
                                    selectedItemColor: AppColors.SECOND_COLOR,
                                    onSelectionDone: (value) {
                                      setState(() {
                                        controlSearch =
                                            items.indexOf(value.toString());
                                      });
                                      blocAtm.add(AtmFilterEvent(
                                          atms: atms.value,
                                          type: controlSearch,
                                          indexSearch: _searchIndex));
                                    },
                                    itemAsString: (item) => item,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      //padding: EdgeInsets.only(left: 5, right: 5, top: 0),
                      child: BlocBuilder<AtmBloc, AtmState>(
                          bloc: blocAtm,
                          builder: (context, state) {
                            if (state is AtmInitialState) {
                              return Text("INIT");
                            }
                            if (state is AtmFailureState) {
                              if (state.code == 401) {
                                return Center(
                                  child: AtmReloadComponent(
                                    state: state,
                                    actionSumbit: () {
                                      final secureStorage =
                                          FlutterSecureStorage();
                                      secureStorage.delete(key: "access_token");
                                      Get.to(LoginScreen());
                                    },
                                    text: "AUTENTICAR",
                                  ),
                                );
                              }
                              return Center(
                                child: AtmReloadComponent(
                                  state: state,
                                  actionSumbit: () {
                                    blocAtm.add(
                                      AtmReloadEvent(
                                        atms: atms.value,
                                        type: controlSearch,
                                        indexSearch: _searchIndex,
                                        query: query,
                                      ),
                                    );
                                  },
                                  text: "CARREGAR",
                                ),
                              );
                            }

                            if (state is AtmSuccessState) {
                              if (controleState == true) {
                                atms.value = state.atms;
                                controleState = false;
                              }
                              count.value = state.atms.length;

                              control = true;
                              if (state.atms.length == 0) {
                                return Container(
                                  width: double.infinity,
                                  height: 50,
                                  child: Text("OK0"),
                                );
                              }
                              print("TAMANHO ${state.atms.length}");
                              MapBloc blocMap = MapBloc();
                              // blocMap.add(MapLoadingEvent(atms: state.atms));
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(5),
                                    height: 50,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              contador = atms.value.length;
                                              _searchIndex = 0;
                                            });
                                            blocAtm.add(
                                              AtmFilterEvent(
                                                  atms: atms.value,
                                                  type: controlSearch,
                                                  indexSearch: _searchIndex),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                                color: (_searchIndex == 0)
                                                    ? AppColors.MAIN_COLOR
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceTint,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .shadow
                                                        .withOpacity(.2),
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ]),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.close,
                                                  color: (_searchIndex == 0)
                                                      ? Colors.white
                                                      : AppColors.MAIN_COLOR,
                                                ),
                                                Text(
                                                  "TODOS ATMS",
                                                  style: GoogleFonts.rajdhani(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: (_searchIndex == 0)
                                                        ? Colors.white
                                                        : AppColors.MAIN_COLOR,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                (_searchIndex == 0)
                                                    ? Text(
                                                        "",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              (_searchIndex ==
                                                                      0)
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                        ),
                                                      )
                                                    : Text(""),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              contador = atms.value.length;

                                              //print("CONTADOR $contador");
                                              _searchIndex = 1;
                                            });
                                            blocAtm.add(
                                              AtmFilterEvent(
                                                  atms: atms.value,
                                                  type: controlSearch,
                                                  indexSearch: _searchIndex),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                              color: (_searchIndex == 1)
                                                  ? AppColors.GREEN_COLOR
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                              border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surfaceTint,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .shadow
                                                      .withOpacity(.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.attach_money,
                                                  color: (_searchIndex == 1)
                                                      ? AppColors.WHITE_COLOR
                                                      : AppColors.GREEN_COLOR,
                                                ),
                                                Text(
                                                  "COM DINHEIRO",
                                                  style: GoogleFonts.rajdhani(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: (_searchIndex == 1)
                                                        ? AppColors.WHITE_COLOR
                                                        : AppColors.GREEN_COLOR,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                (_searchIndex == 1)
                                                    ? Text(
                                                        "",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              (_searchIndex ==
                                                                      1)
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .green,
                                                        ),
                                                      )
                                                    : Text(""),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            print(
                                                "Repara ${atms.value.length}");
                                            setState(() {
                                              _searchIndex = 2;
                                            });
                                            blocAtm.add(
                                              AtmFilterEvent(
                                                  atms: atms.value,
                                                  type: controlSearch,
                                                  indexSearch: _searchIndex),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                              color: (_searchIndex == 2)
                                                  ? AppColors.RED_COLOR
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                              border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surfaceTint,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .shadow
                                                      .withOpacity(.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.money_off_csred,
                                                  color: (_searchIndex == 2)
                                                      ? AppColors.WHITE_COLOR
                                                      : AppColors.RED_COLOR,
                                                ),
                                                Text(
                                                  "SEM DINHEIRO",
                                                  style: GoogleFonts.rajdhani(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: (_searchIndex == 2)
                                                        ? AppColors.WHITE_COLOR
                                                        : AppColors.RED_COLOR,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                (_searchIndex == 2)
                                                    ? Text(
                                                        "",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              (_searchIndex ==
                                                                      2)
                                                                  ? Colors.white
                                                                  : Colors.red,
                                                        ),
                                                      )
                                                    : Text(""),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _searchIndex = 3;
                                            });
                                            blocAtm.add(
                                              AtmFilterEvent(
                                                  atms: atms.value,
                                                  type: controlSearch,
                                                  indexSearch: _searchIndex),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                              color: (_searchIndex == 3)
                                                  ? AppColors.ORANGE_COLOR
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                              border: Border.all(
                                                width: 1,
                                                color: (_searchIndex == 3)
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .surfaceTint
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surfaceTint,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .shadow
                                                      .withOpacity(.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.money_off,
                                                  color: (_searchIndex == 3)
                                                      ? AppColors.WHITE_COLOR
                                                      : Colors.orange,
                                                ),
                                                Text(
                                                  "POUCO DINHEIRO",
                                                  style: GoogleFonts.rajdhani(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: (_searchIndex == 3)
                                                        ? AppColors.WHITE_COLOR
                                                        : Colors.orange,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                (_searchIndex == 3)
                                                    ? Text(
                                                        "",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              (_searchIndex ==
                                                                      3)
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .green,
                                                        ),
                                                      )
                                                    : Text(""),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _searchIndex = 4;
                                            });
                                            blocAtm.add(
                                              AtmFilterEvent(
                                                  atms: atms.value,
                                                  type: controlSearch,
                                                  indexSearch: _searchIndex),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                              color: (_searchIndex == 4)
                                                  ? AppColors.RED_COLOR
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                              border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surfaceTint,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .shadow
                                                      .withOpacity(.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.sd_card_alert_rounded,
                                                  color: (_searchIndex == 4)
                                                      ? AppColors.WHITE_COLOR
                                                      : AppColors.RED_COLOR,
                                                ),
                                                Text(
                                                  "ANOMALIA CARTÃO",
                                                  style: GoogleFonts.rajdhani(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: (_searchIndex == 4)
                                                        ? AppColors.WHITE_COLOR
                                                        : AppColors.RED_COLOR,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                (_searchIndex == 4)
                                                    ? Text(
                                                        "",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              (_searchIndex ==
                                                                      4)
                                                                  ? Colors.white
                                                                  : Colors.red,
                                                        ),
                                                      )
                                                    : Text(""),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _searchIndex = 5;
                                            });
                                            blocAtm.add(
                                              AtmFilterEvent(
                                                  atms: atms.value,
                                                  type: controlSearch,
                                                  indexSearch: _searchIndex),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                              color: (_searchIndex == 5)
                                                  ? AppColors.GREEN_COLOR
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                              border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surfaceTint,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .shadow
                                                      .withOpacity(.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.wifi,
                                                  color: (_searchIndex == 5)
                                                      ? AppColors.WHITE_COLOR
                                                      : AppColors.GREEN_COLOR,
                                                ),
                                                Text(
                                                  "ONLINE",
                                                  style: GoogleFonts.rajdhani(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: (_searchIndex == 5)
                                                        ? AppColors.WHITE_COLOR
                                                        : AppColors.GREEN_COLOR,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                (_searchIndex == 5)
                                                    ? Text(
                                                        "",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              (_searchIndex ==
                                                                      5)
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .green,
                                                        ),
                                                      )
                                                    : Text(""),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _searchIndex = 7;
                                            });
                                            blocAtm.add(
                                              AtmFilterEvent(
                                                  atms: atms.value,
                                                  type: controlSearch,
                                                  indexSearch: _searchIndex),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                              color: (_searchIndex == 7)
                                                  ? AppColors.ORANGE_COLOR
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                              border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surfaceTint,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .shadow
                                                      .withOpacity(.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.trending_down_rounded,
                                                  color: (_searchIndex == 7)
                                                      ? AppColors.WHITE_COLOR
                                                      : AppColors.ORANGE_COLOR,
                                                ),
                                                Text(
                                                  "ABAIXO DE \$\3 MILHOES",
                                                  style: GoogleFonts.rajdhani(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: (_searchIndex == 7)
                                                        ? AppColors.WHITE_COLOR
                                                        : AppColors
                                                            .ORANGE_COLOR,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                (_searchIndex == 7)
                                                    ? Text(
                                                        "",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              (_searchIndex ==
                                                                      7)
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .orange,
                                                        ),
                                                      )
                                                    : Text(""),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _searchIndex = 8;
                                            });
                                            blocAtm.add(
                                              AtmFilterEvent(
                                                  atms: atms.value,
                                                  type: controlSearch,
                                                  indexSearch: _searchIndex),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                              color: (_searchIndex == 8)
                                                  ? AppColors.RED_COLOR
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                              border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surfaceTint,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .shadow
                                                      .withOpacity(.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.wifi_off_rounded,
                                                  color: (_searchIndex == 8)
                                                      ? AppColors.WHITE_COLOR
                                                      : Colors.red,
                                                ),
                                                Text(
                                                  "OFFLINE",
                                                  style: GoogleFonts.rajdhani(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: (_searchIndex == 8)
                                                        ? AppColors.WHITE_COLOR
                                                        : Colors.red,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                (_searchIndex == 8)
                                                    ? Text(
                                                        "",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              (_searchIndex ==
                                                                      8)
                                                                  ? Colors.white
                                                                  : Colors.red,
                                                        ),
                                                      )
                                                    : Text(""),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _searchIndex = 9;
                                            });
                                            blocAtm.add(
                                              AtmFilterEvent(
                                                  atms: atms.value,
                                                  type: controlSearch,
                                                  indexSearch: _searchIndex),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                              color: (_searchIndex == 9)
                                                  ? Colors.green
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                              border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surfaceTint,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .shadow
                                                      .withOpacity(.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.check_box,
                                                  color: (_searchIndex == 9)
                                                      ? Colors.white
                                                      : Colors.green,
                                                ),
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    "COM PAPEL",
                                                    style: GoogleFonts.rajdhani(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: (_searchIndex == 9)
                                                          ? Colors.white
                                                          : Colors.green,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                (_searchIndex == 9)
                                                    ? Text(
                                                        "",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              (_searchIndex ==
                                                                      9)
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .green,
                                                        ),
                                                      )
                                                    : Text(""),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _searchIndex = 10;
                                            });
                                            blocAtm.add(
                                              AtmFilterEvent(
                                                  atms: atms.value,
                                                  type: controlSearch,
                                                  indexSearch: _searchIndex),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                              color: (_searchIndex == 10)
                                                  ? Colors.red
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                              border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surfaceTint,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .shadow
                                                      .withOpacity(.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .cancel_presentation_outlined,
                                                  color: (_searchIndex == 10)
                                                      ? Colors.white
                                                      : Colors.red,
                                                ),
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    "SEM PAPEL",
                                                    style: GoogleFonts.rajdhani(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color:
                                                          (_searchIndex == 10)
                                                              ? Colors.white
                                                              : Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                (_searchIndex == 10)
                                                    ? Text(
                                                        "",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              (_searchIndex ==
                                                                      10)
                                                                  ? Colors.white
                                                                  : Colors.red,
                                                        ),
                                                      )
                                                    : Text(""),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _searchIndex = 11;
                                            });
                                            blocAtm.add(
                                              AtmFilterEvent(
                                                  atms: atms.value,
                                                  type: controlSearch,
                                                  indexSearch: _searchIndex),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                              color: (_searchIndex == 11)
                                                  ? Colors.orange
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                              border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surfaceTint,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .shadow
                                                      .withOpacity(.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.warning_amber,
                                                  color: (_searchIndex == 11)
                                                      ? Colors.white
                                                      : Colors.orange,
                                                ),
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    "POUCO PAPEL",
                                                    style: GoogleFonts.rajdhani(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color:
                                                          (_searchIndex == 11)
                                                              ? Colors.white
                                                              : Colors.orange,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                (_searchIndex == 11)
                                                    ? Text(
                                                        "",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              (_searchIndex ==
                                                                      11)
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .orange,
                                                        ),
                                                      )
                                                    : Text(""),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: BlocBuilder<MapBloc, MapState>(
                                      bloc: blocMap
                                        ..add(
                                            MapLoadingEvent(atms: state.atms)),
                                      builder: (context, stateAtmMap) {
                                        if (stateAtmMap is MapInitState) {
                                          blocMap.add(MapLoadingEvent(
                                              atms: state.atms));
                                        } else if (stateAtmMap
                                            is MapLoadingState) {
                                          return Text("CAA");
                                        } else if (stateAtmMap
                                            is MapLoadedState) {
                                          return GoogleMap(
                                            onMapCreated: (GoogleMapController
                                                controller) {
                                              mapController = controller;
                                              mapController
                                                  ?.setMapStyle(_mapStyle);
                                            },
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: LatLng(
                                                  -8.9039071, 13.1833099),
                                              zoom: 14,
                                            ),
                                            mapType: MapType.normal,
                                            myLocationEnabled: true,
                                            markers: stateAtmMap.markers,
                                            circles: {
                                              Circle(
                                                circleId: CircleId("1"),
                                                center: LatLng(
                                                  -8.9039071,
                                                  13.1833099,
                                                ),
                                                radius: 5000,
                                                fillColor: Colors.blue
                                                    .withOpacity(0.05),
                                                strokeWidth: 2,
                                                strokeColor: Colors.blue,
                                              )
                                            },
                                          );
                                        }

                                        return Center(child: Text("data"));
                                      },
                                    ),
                                  ),
                                ],
                              );

                              return FloatingDraggableWidget(
                                floatingWidget: Container(
                                  width: 50,
                                  height: 100,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: AppColors.MAIN_COLOR,
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .shadow
                                              .withOpacity(.5),
                                          spreadRadius: 2,
                                          blurRadius: 1,
                                          offset: Offset(0, 0),
                                        ),
                                      ]),
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "${count.value}",
                                        style: GoogleFonts.rajdhani(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 20,
                                          color: AppColors.WHITE_COLOR,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                floatingWidgetHeight: 50,
                                floatingWidgetWidth: 50,
                                dx: 0,
                                dy: 200,
                                autoAlign: false,
                                resizeToAvoidBottomInset: false,
                                deleteWidgetAnimationCurve: Curves.linear,
                                deleteWidgetAlignment: Alignment.center,
                                mainScreenWidget: Container(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(5),
                                        height: 50,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  contador = atms.value.length;
                                                  _searchIndex = 0;
                                                });
                                                blocAtm.add(
                                                  AtmFilterEvent(
                                                      atms: atms.value,
                                                      type: controlSearch,
                                                      indexSearch:
                                                          _searchIndex),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: (_searchIndex == 0)
                                                        ? AppColors.MAIN_COLOR
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surfaceTint,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .shadow
                                                            .withOpacity(.2),
                                                        spreadRadius: 1,
                                                        blurRadius: 1,
                                                        offset: Offset(0, 1),
                                                      ),
                                                    ]),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.close,
                                                      color: (_searchIndex == 0)
                                                          ? Colors.white
                                                          : AppColors
                                                              .MAIN_COLOR,
                                                    ),
                                                    Text(
                                                      "TODOS ATMS",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color:
                                                            (_searchIndex == 0)
                                                                ? Colors.white
                                                                : AppColors
                                                                    .MAIN_COLOR,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    (_searchIndex == 0)
                                                        ? Text(
                                                            "",
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color:
                                                                  (_searchIndex ==
                                                                          0)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                            ),
                                                          )
                                                        : Text(""),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  contador = atms.value.length;

                                                  //print("CONTADOR $contador");
                                                  _searchIndex = 1;
                                                });
                                                blocAtm.add(
                                                  AtmFilterEvent(
                                                      atms: atms.value,
                                                      type: controlSearch,
                                                      indexSearch:
                                                          _searchIndex),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: (_searchIndex == 1)
                                                      ? AppColors.GREEN_COLOR
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surfaceTint,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow
                                                          .withOpacity(.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 1,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.attach_money,
                                                      color: (_searchIndex == 1)
                                                          ? AppColors
                                                              .WHITE_COLOR
                                                          : AppColors
                                                              .GREEN_COLOR,
                                                    ),
                                                    Text(
                                                      "COM DINHEIRO",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color: (_searchIndex ==
                                                                1)
                                                            ? AppColors
                                                                .WHITE_COLOR
                                                            : AppColors
                                                                .GREEN_COLOR,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    (_searchIndex == 1)
                                                        ? Text(
                                                            "",
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color:
                                                                  (_searchIndex ==
                                                                          1)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .green,
                                                            ),
                                                          )
                                                        : Text(""),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                print(
                                                    "Repara ${atms.value.length}");
                                                setState(() {
                                                  _searchIndex = 2;
                                                });
                                                blocAtm.add(
                                                  AtmFilterEvent(
                                                      atms: atms.value,
                                                      type: controlSearch,
                                                      indexSearch:
                                                          _searchIndex),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: (_searchIndex == 2)
                                                      ? AppColors.RED_COLOR
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surfaceTint,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow
                                                          .withOpacity(.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 1,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.money_off_csred,
                                                      color: (_searchIndex == 2)
                                                          ? AppColors
                                                              .WHITE_COLOR
                                                          : AppColors.RED_COLOR,
                                                    ),
                                                    Text(
                                                      "SEM DINHEIRO",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color:
                                                            (_searchIndex == 2)
                                                                ? AppColors
                                                                    .WHITE_COLOR
                                                                : AppColors
                                                                    .RED_COLOR,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    (_searchIndex == 2)
                                                        ? Text(
                                                            "",
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color:
                                                                  (_searchIndex ==
                                                                          2)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .red,
                                                            ),
                                                          )
                                                        : Text(""),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _searchIndex = 3;
                                                });
                                                blocAtm.add(
                                                  AtmFilterEvent(
                                                      atms: atms.value,
                                                      type: controlSearch,
                                                      indexSearch:
                                                          _searchIndex),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: (_searchIndex == 3)
                                                      ? AppColors.ORANGE_COLOR
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  border: Border.all(
                                                    width: 1,
                                                    color: (_searchIndex == 3)
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .surfaceTint
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .surfaceTint,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow
                                                          .withOpacity(.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 1,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.money_off,
                                                      color: (_searchIndex == 3)
                                                          ? AppColors
                                                              .WHITE_COLOR
                                                          : Colors.orange,
                                                    ),
                                                    Text(
                                                      "POUCO DINHEIRO",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color:
                                                            (_searchIndex == 3)
                                                                ? AppColors
                                                                    .WHITE_COLOR
                                                                : Colors.orange,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    (_searchIndex == 3)
                                                        ? Text(
                                                            "",
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color:
                                                                  (_searchIndex ==
                                                                          3)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .green,
                                                            ),
                                                          )
                                                        : Text(""),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _searchIndex = 4;
                                                });
                                                blocAtm.add(
                                                  AtmFilterEvent(
                                                      atms: atms.value,
                                                      type: controlSearch,
                                                      indexSearch:
                                                          _searchIndex),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: (_searchIndex == 4)
                                                      ? AppColors.RED_COLOR
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surfaceTint,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow
                                                          .withOpacity(.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 1,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .sd_card_alert_rounded,
                                                      color: (_searchIndex == 4)
                                                          ? AppColors
                                                              .WHITE_COLOR
                                                          : AppColors.RED_COLOR,
                                                    ),
                                                    Text(
                                                      "ANOMALIA CARTÃO",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color:
                                                            (_searchIndex == 4)
                                                                ? AppColors
                                                                    .WHITE_COLOR
                                                                : AppColors
                                                                    .RED_COLOR,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    (_searchIndex == 4)
                                                        ? Text(
                                                            "",
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color:
                                                                  (_searchIndex ==
                                                                          4)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .red,
                                                            ),
                                                          )
                                                        : Text(""),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _searchIndex = 5;
                                                });
                                                blocAtm.add(
                                                  AtmFilterEvent(
                                                      atms: atms.value,
                                                      type: controlSearch,
                                                      indexSearch:
                                                          _searchIndex),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: (_searchIndex == 5)
                                                      ? AppColors.GREEN_COLOR
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surfaceTint,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow
                                                          .withOpacity(.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 1,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.wifi,
                                                      color: (_searchIndex == 5)
                                                          ? AppColors
                                                              .WHITE_COLOR
                                                          : AppColors
                                                              .GREEN_COLOR,
                                                    ),
                                                    Text(
                                                      "ONLINE",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color: (_searchIndex ==
                                                                5)
                                                            ? AppColors
                                                                .WHITE_COLOR
                                                            : AppColors
                                                                .GREEN_COLOR,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    (_searchIndex == 5)
                                                        ? Text(
                                                            "",
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color:
                                                                  (_searchIndex ==
                                                                          5)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .green,
                                                            ),
                                                          )
                                                        : Text(""),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _searchIndex = 7;
                                                });
                                                blocAtm.add(
                                                  AtmFilterEvent(
                                                      atms: atms.value,
                                                      type: controlSearch,
                                                      indexSearch:
                                                          _searchIndex),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: (_searchIndex == 7)
                                                      ? AppColors.ORANGE_COLOR
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surfaceTint,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow
                                                          .withOpacity(.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 1,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .trending_down_rounded,
                                                      color: (_searchIndex == 7)
                                                          ? AppColors
                                                              .WHITE_COLOR
                                                          : AppColors
                                                              .ORANGE_COLOR,
                                                    ),
                                                    Text(
                                                      "ABAIXO DE \$\3 MILHOES",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color: (_searchIndex ==
                                                                7)
                                                            ? AppColors
                                                                .WHITE_COLOR
                                                            : AppColors
                                                                .ORANGE_COLOR,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    (_searchIndex == 7)
                                                        ? Text(
                                                            "",
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color:
                                                                  (_searchIndex ==
                                                                          7)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .orange,
                                                            ),
                                                          )
                                                        : Text(""),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _searchIndex = 8;
                                                });
                                                blocAtm.add(
                                                  AtmFilterEvent(
                                                      atms: atms.value,
                                                      type: controlSearch,
                                                      indexSearch:
                                                          _searchIndex),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: (_searchIndex == 8)
                                                      ? AppColors.RED_COLOR
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surfaceTint,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow
                                                          .withOpacity(.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 1,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.wifi_off_rounded,
                                                      color: (_searchIndex == 8)
                                                          ? AppColors
                                                              .WHITE_COLOR
                                                          : Colors.red,
                                                    ),
                                                    Text(
                                                      "OFFLINE",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color:
                                                            (_searchIndex == 8)
                                                                ? AppColors
                                                                    .WHITE_COLOR
                                                                : Colors.red,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    (_searchIndex == 8)
                                                        ? Text(
                                                            "",
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color:
                                                                  (_searchIndex ==
                                                                          8)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .red,
                                                            ),
                                                          )
                                                        : Text(""),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _searchIndex = 9;
                                                });
                                                blocAtm.add(
                                                  AtmFilterEvent(
                                                      atms: atms.value,
                                                      type: controlSearch,
                                                      indexSearch:
                                                          _searchIndex),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: (_searchIndex == 9)
                                                      ? Colors.green
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surfaceTint,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow
                                                          .withOpacity(.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 1,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.check_box,
                                                      color: (_searchIndex == 9)
                                                          ? Colors.white
                                                          : Colors.green,
                                                    ),
                                                    FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        "COM PAPEL",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          color:
                                                              (_searchIndex ==
                                                                      9)
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .green,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    (_searchIndex == 9)
                                                        ? Text(
                                                            "",
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color:
                                                                  (_searchIndex ==
                                                                          9)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .green,
                                                            ),
                                                          )
                                                        : Text(""),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _searchIndex = 10;
                                                });
                                                blocAtm.add(
                                                  AtmFilterEvent(
                                                      atms: atms.value,
                                                      type: controlSearch,
                                                      indexSearch:
                                                          _searchIndex),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: (_searchIndex == 10)
                                                      ? Colors.red
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surfaceTint,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow
                                                          .withOpacity(.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 1,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .cancel_presentation_outlined,
                                                      color:
                                                          (_searchIndex == 10)
                                                              ? Colors.white
                                                              : Colors.red,
                                                    ),
                                                    FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        "SEM PAPEL",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          color:
                                                              (_searchIndex ==
                                                                      10)
                                                                  ? Colors.white
                                                                  : Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    (_searchIndex == 10)
                                                        ? Text(
                                                            "",
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: (_searchIndex ==
                                                                      10)
                                                                  ? Colors.white
                                                                  : Colors.red,
                                                            ),
                                                          )
                                                        : Text(""),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _searchIndex = 11;
                                                });
                                                blocAtm.add(
                                                  AtmFilterEvent(
                                                      atms: atms.value,
                                                      type: controlSearch,
                                                      indexSearch:
                                                          _searchIndex),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: (_searchIndex == 11)
                                                      ? Colors.orange
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surfaceTint,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow
                                                          .withOpacity(.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 1,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.warning_amber,
                                                      color:
                                                          (_searchIndex == 11)
                                                              ? Colors.white
                                                              : Colors.orange,
                                                    ),
                                                    FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        "POUCO PAPEL",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          color:
                                                              (_searchIndex ==
                                                                      11)
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .orange,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    (_searchIndex == 11)
                                                        ? Text(
                                                            "",
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: (_searchIndex ==
                                                                      11)
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .orange,
                                                            ),
                                                          )
                                                        : Text(""),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: BlocBuilder<MapBloc, MapState>(
                                          builder: (context, state) {
                                            if (state is MapLoadingState) {
                                              return Center(
                                                child: Center(
                                                    child:
                                                        Text("Carregando...")),
                                              );
                                            } else if (state
                                                is MapLoadedState) {
                                              // return Stack(
                                              //   children: [
                                              //     Positioned(
                                              //       top: 70,
                                              //       left: 20,
                                              //       right: 20,
                                              //       child: Container(
                                              //         height: 50,
                                              //         child: Row(
                                              //           mainAxisAlignment:
                                              //               MainAxisAlignment
                                              //                   .spaceBetween,
                                              //           children: [
                                              //             Container(
                                              //                 padding:
                                              //                     EdgeInsets
                                              //                         .all(8),
                                              //                 decoration:
                                              //                     BoxDecoration(
                                              //                   color: Colors
                                              //                       .white,
                                              //                   borderRadius:
                                              //                       BorderRadius
                                              //                           .circular(
                                              //                               50),
                                              //                   boxShadow: [
                                              //                     BoxShadow(
                                              //                       color: Colors
                                              //                           .black26
                                              //                           .withOpacity(
                                              //                               .3),
                                              //                       blurRadius:
                                              //                           2,
                                              //                       spreadRadius:
                                              //                           1,
                                              //                     ),
                                              //                   ],
                                              //                 ),
                                              //                 child: Icon(
                                              //                   Icons
                                              //                       .arrow_back_sharp,
                                              //                   size: 25,
                                              //                   color: AppColors
                                              //                       .MAIN_COLOR,
                                              //                 )),
                                              //             Expanded(
                                              //               child: Container(
                                              //                 width: 200,
                                              //                 child:
                                              //                     FlutterSlider(
                                              //                   values: [300],
                                              //                   max: 500,
                                              //                   min: 0,
                                              //                   onDragging: (handlerIndex,
                                              //                       lowerValue,
                                              //                       upperValue) {
                                              //                     print(
                                              //                         lowerValue);
                                              //                     print(
                                              //                         handlerIndex);
                                              //                     print(
                                              //                         upperValue);
                                              //                     // _lowerValue = lowerValue;
                                              //                     // _upperValue = upperValue;
                                              //                     setState(
                                              //                         () {});
                                              //                   },
                                              //                   trackBar:
                                              //                       FlutterSliderTrackBar(
                                              //                     inactiveTrackBar:
                                              //                         BoxDecoration(
                                              //                       borderRadius:
                                              //                           BorderRadius.circular(
                                              //                               20),
                                              //                       color: Colors
                                              //                           .black12,
                                              //                       border: Border.all(
                                              //                           width:
                                              //                               3,
                                              //                           color:
                                              //                               Colors.blue),
                                              //                     ),
                                              //                     activeTrackBar: BoxDecoration(
                                              //                         borderRadius:
                                              //                             BorderRadius.circular(
                                              //                                 4),
                                              //                         color: Colors
                                              //                             .blue
                                              //                             .withOpacity(0.5)),
                                              //                   ),
                                              //                 ),
                                              //               ),
                                              //             ),
                                              //             Container(
                                              //               decoration:
                                              //                   BoxDecoration(
                                              //                 color: Colors
                                              //                     .white,
                                              //                 borderRadius:
                                              //                     BorderRadius
                                              //                         .circular(
                                              //                             50),
                                              //                 boxShadow: [
                                              //                   BoxShadow(
                                              //                     color: Colors
                                              //                         .black26
                                              //                         .withOpacity(
                                              //                             .3),
                                              //                     blurRadius:
                                              //                         5,
                                              //                     spreadRadius:
                                              //                         1,
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //               child: Container(
                                              //                 padding:
                                              //                     EdgeInsets
                                              //                         .all(8),
                                              //                 child: Row(
                                              //                   children: [
                                              //                     SizedBox(
                                              //                       width: 10,
                                              //                     ),
                                              //                     Text(
                                              //                       "ATM",
                                              //                       style: GoogleFonts
                                              //                           .racingSansOne(
                                              //                         fontSize:
                                              //                             20,
                                              //                         color: AppColors
                                              //                             .MAIN_COLOR,
                                              //                       ),
                                              //                     ),
                                              //                     Icon(
                                              //                       Icons
                                              //                           .arrow_right,
                                              //                       size: 25,
                                              //                       color: AppColors
                                              //                           .MAIN_COLOR,
                                              //                     ),
                                              //                   ],
                                              //                 ),
                                              //               ),
                                              //             ),
                                              //           ],
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ],
                                              // );
                                              return GoogleMap(
                                                onMapCreated:
                                                    (GoogleMapController
                                                        controller) {
                                                  mapController = controller;
                                                  mapController
                                                      ?.setMapStyle(_mapStyle);
                                                },
                                                initialCameraPosition:
                                                    CameraPosition(
                                                  target: LatLng(
                                                      -8.9039071, 13.1833099),
                                                  zoom: 14,
                                                ),
                                                mapType: MapType.normal,
                                                myLocationEnabled: true,
                                                markers: state.markers,
                                                circles: {
                                                  Circle(
                                                    circleId: CircleId("1"),
                                                    center: LatLng(
                                                      -8.9039071,
                                                      13.1833099,
                                                    ),
                                                    radius: 5000,
                                                    fillColor: Colors.blue
                                                        .withOpacity(0.1),
                                                    strokeWidth: 2,
                                                    strokeColor: Colors.blue,
                                                  )
                                                },
                                              );
                                            }

                                            print(state);
                                            return Center(child: Text("data"));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return Container();
                          }),
                    ),
                  ),
                ],
              ),
            );
          }

          print(state);
          return Center(child: Text("data"));
        },
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            blocAtm.add(
              AtmReloadEvent(
                atms: atms.value,
                type: controlSearch,
                query: query,
                indexSearch: _searchIndex,
              ),
            );
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  padding:
                      EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 8),
                  child: Stack(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 120),
                                height: 40,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceTint
                                        .withOpacity(.5),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .shadow
                                          .withOpacity(.2),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _query,
                                  style: GoogleFonts.rajdhani(
                                    fontWeight: FontWeight.w900,
                                  ),
                                  onChanged: (value) {
                                    query = value;
                                    blocAtm.add(AtmSearchEvent(
                                        atms: atms.value,
                                        query: value,
                                        type: controlSearch,
                                        indexSearch: _searchIndex));
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Pesquisar...",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 11.0,
                                    ), // Reduza o espaçamento vertical
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 3,
                        top: 3,
                        child: Container(
                          height: 34,
                          width: 110,
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: AppColors.MAIN_BACKGROUND,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomSingleSelectField<Object>(
                                  items: items,
                                  title: "TIPOS DE ATM",
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: Row(
                                      children: [
                                        Container(
                                          width: 70,
                                          child: Text(
                                            "${items.elementAt(controlSearch)}",
                                            style: GoogleFonts.racingSansOne(
                                              fontSize: 18,
                                              color: AppColors.SECOND_COLOR,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          color: AppColors.SECOND_COLOR,
                                          Icons.arrow_forward_ios_rounded,
                                        )
                                      ],
                                    ),
                                    labelStyle: GoogleFonts.rajdhani(
                                      fontSize: 8,
                                      color: Colors.red,
                                    ),
                                    suffixIconColor: Colors.white,
                                    focusColor: Colors.white,
                                  ),
                                  selectedItemColor: AppColors.SECOND_COLOR,
                                  onSelectionDone: (value) {
                                    setState(() {
                                      controlSearch =
                                          items.indexOf(value.toString());
                                    });
                                    blocAtm.add(AtmFilterEvent(
                                        atms: atms.value,
                                        type: controlSearch,
                                        indexSearch: _searchIndex));
                                  },
                                  itemAsString: (item) => item,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    //padding: EdgeInsets.only(left: 5, right: 5, top: 0),
                    child: BlocBuilder<AtmBloc, AtmState>(
                        bloc: blocAtm,
                        builder: (context, state) {
                          if (state is AtmInitialState) {
                            return Text("INIT");
                          }
                          if (state is AtmFailureState) {
                            if (state.code == 401) {
                              return Center(
                                child: AtmReloadComponent(
                                  state: state,
                                  actionSumbit: () {
                                    final secureStorage =
                                        FlutterSecureStorage();
                                    secureStorage.delete(key: "access_token");
                                    Get.to(LoginScreen());
                                  },
                                  text: "AUTENTICAR",
                                ),
                              );
                            }
                            return Center(
                              child: AtmReloadComponent(
                                state: state,
                                actionSumbit: () {
                                  blocAtm.add(
                                    AtmReloadEvent(
                                      atms: atms.value,
                                      type: controlSearch,
                                      indexSearch: _searchIndex,
                                      query: query,
                                    ),
                                  );
                                },
                                text: "CARREGAR",
                              ),
                            );
                          }

                          if (state is AtmSuccessState) {
                            if (controleState == true) {
                              atms.value = state.atms;
                              controleState = false;
                            }
                            count.value = state.atms.length;

                            control = true;
                            if (state.atms.length == 0) {
                              return Container(
                                width: double.infinity,
                                height: 50,
                                child: Text("OK0"),
                              );
                            }
                            return FloatingDraggableWidget(
                              floatingWidget: Container(
                                width: 50,
                                height: 100,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: AppColors.MAIN_COLOR,
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .shadow
                                            .withOpacity(.5),
                                        spreadRadius: 2,
                                        blurRadius: 1,
                                        offset: Offset(0, 0),
                                      ),
                                    ]),
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "${count.value}",
                                      style: GoogleFonts.rajdhani(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20,
                                        color: AppColors.WHITE_COLOR,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              floatingWidgetHeight: 50,
                              floatingWidgetWidth: 50,
                              dx: 0,
                              dy: 200,
                              autoAlign: false,
                              resizeToAvoidBottomInset: false,
                              deleteWidgetAnimationCurve: Curves.linear,
                              deleteWidgetAlignment: Alignment.center,
                              mainScreenWidget: Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(5),
                                      height: 50,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                contador = atms.value.length;
                                                _searchIndex = 0;
                                              });
                                              blocAtm.add(
                                                AtmFilterEvent(
                                                    atms: atms.value,
                                                    type: controlSearch,
                                                    indexSearch: _searchIndex),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: (_searchIndex == 0)
                                                      ? AppColors.MAIN_COLOR
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surfaceTint,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow
                                                          .withOpacity(.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 1,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ]),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.close,
                                                    color: (_searchIndex == 0)
                                                        ? Colors.white
                                                        : AppColors.MAIN_COLOR,
                                                  ),
                                                  Text(
                                                    "TODOS ATMS",
                                                    style: GoogleFonts.rajdhani(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: (_searchIndex == 0)
                                                          ? Colors.white
                                                          : AppColors
                                                              .MAIN_COLOR,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  (_searchIndex == 0)
                                                      ? Text(
                                                          "",
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                (_searchIndex ==
                                                                        0)
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                          ),
                                                        )
                                                      : Text(""),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                contador = atms.value.length;

                                                //print("CONTADOR $contador");
                                                _searchIndex = 1;
                                              });
                                              blocAtm.add(
                                                AtmFilterEvent(
                                                    atms: atms.value,
                                                    type: controlSearch,
                                                    indexSearch: _searchIndex),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              decoration: BoxDecoration(
                                                color: (_searchIndex == 1)
                                                    ? AppColors.GREEN_COLOR
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceTint,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .shadow
                                                        .withOpacity(.2),
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.attach_money,
                                                    color: (_searchIndex == 1)
                                                        ? AppColors.WHITE_COLOR
                                                        : AppColors.GREEN_COLOR,
                                                  ),
                                                  Text(
                                                    "COM DINHEIRO",
                                                    style: GoogleFonts.rajdhani(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: (_searchIndex == 1)
                                                          ? AppColors
                                                              .WHITE_COLOR
                                                          : AppColors
                                                              .GREEN_COLOR,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  (_searchIndex == 1)
                                                      ? Text(
                                                          "",
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                (_searchIndex ==
                                                                        1)
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .green,
                                                          ),
                                                        )
                                                      : Text(""),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              print(
                                                  "Repara ${atms.value.length}");
                                              setState(() {
                                                _searchIndex = 2;
                                              });
                                              blocAtm.add(
                                                AtmFilterEvent(
                                                    atms: atms.value,
                                                    type: controlSearch,
                                                    indexSearch: _searchIndex),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              decoration: BoxDecoration(
                                                color: (_searchIndex == 2)
                                                    ? AppColors.RED_COLOR
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceTint,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .shadow
                                                        .withOpacity(.2),
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.money_off_csred,
                                                    color: (_searchIndex == 2)
                                                        ? AppColors.WHITE_COLOR
                                                        : AppColors.RED_COLOR,
                                                  ),
                                                  Text(
                                                    "SEM DINHEIRO",
                                                    style: GoogleFonts.rajdhani(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: (_searchIndex == 2)
                                                          ? AppColors
                                                              .WHITE_COLOR
                                                          : AppColors.RED_COLOR,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  (_searchIndex == 2)
                                                      ? Text(
                                                          "",
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                (_searchIndex ==
                                                                        2)
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .red,
                                                          ),
                                                        )
                                                      : Text(""),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _searchIndex = 3;
                                              });
                                              blocAtm.add(
                                                AtmFilterEvent(
                                                    atms: atms.value,
                                                    type: controlSearch,
                                                    indexSearch: _searchIndex),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              decoration: BoxDecoration(
                                                color: (_searchIndex == 3)
                                                    ? AppColors.ORANGE_COLOR
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                border: Border.all(
                                                  width: 1,
                                                  color: (_searchIndex == 3)
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .surfaceTint
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .surfaceTint,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .shadow
                                                        .withOpacity(.2),
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.money_off,
                                                    color: (_searchIndex == 3)
                                                        ? AppColors.WHITE_COLOR
                                                        : Colors.orange,
                                                  ),
                                                  Text(
                                                    "POUCO DINHEIRO",
                                                    style: GoogleFonts.rajdhani(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: (_searchIndex == 3)
                                                          ? AppColors
                                                              .WHITE_COLOR
                                                          : Colors.orange,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  (_searchIndex == 3)
                                                      ? Text(
                                                          "",
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                (_searchIndex ==
                                                                        3)
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .green,
                                                          ),
                                                        )
                                                      : Text(""),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _searchIndex = 4;
                                              });
                                              blocAtm.add(
                                                AtmFilterEvent(
                                                    atms: atms.value,
                                                    type: controlSearch,
                                                    indexSearch: _searchIndex),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              decoration: BoxDecoration(
                                                color: (_searchIndex == 4)
                                                    ? AppColors.RED_COLOR
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceTint,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .shadow
                                                        .withOpacity(.2),
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.sd_card_alert_rounded,
                                                    color: (_searchIndex == 4)
                                                        ? AppColors.WHITE_COLOR
                                                        : AppColors.RED_COLOR,
                                                  ),
                                                  Text(
                                                    "ANOMALIA CARTÃO",
                                                    style: GoogleFonts.rajdhani(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: (_searchIndex == 4)
                                                          ? AppColors
                                                              .WHITE_COLOR
                                                          : AppColors.RED_COLOR,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  (_searchIndex == 4)
                                                      ? Text(
                                                          "",
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                (_searchIndex ==
                                                                        4)
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .red,
                                                          ),
                                                        )
                                                      : Text(""),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _searchIndex = 5;
                                              });
                                              blocAtm.add(
                                                AtmFilterEvent(
                                                    atms: atms.value,
                                                    type: controlSearch,
                                                    indexSearch: _searchIndex),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              decoration: BoxDecoration(
                                                color: (_searchIndex == 5)
                                                    ? AppColors.GREEN_COLOR
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceTint,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .shadow
                                                        .withOpacity(.2),
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.wifi,
                                                    color: (_searchIndex == 5)
                                                        ? AppColors.WHITE_COLOR
                                                        : AppColors.GREEN_COLOR,
                                                  ),
                                                  Text(
                                                    "ONLINE",
                                                    style: GoogleFonts.rajdhani(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: (_searchIndex == 5)
                                                          ? AppColors
                                                              .WHITE_COLOR
                                                          : AppColors
                                                              .GREEN_COLOR,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  (_searchIndex == 5)
                                                      ? Text(
                                                          "",
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                (_searchIndex ==
                                                                        5)
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .green,
                                                          ),
                                                        )
                                                      : Text(""),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _searchIndex = 7;
                                              });
                                              blocAtm.add(
                                                AtmFilterEvent(
                                                    atms: atms.value,
                                                    type: controlSearch,
                                                    indexSearch: _searchIndex),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              decoration: BoxDecoration(
                                                color: (_searchIndex == 7)
                                                    ? AppColors.ORANGE_COLOR
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceTint,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .shadow
                                                        .withOpacity(.2),
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.trending_down_rounded,
                                                    color: (_searchIndex == 7)
                                                        ? AppColors.WHITE_COLOR
                                                        : AppColors
                                                            .ORANGE_COLOR,
                                                  ),
                                                  Text(
                                                    "ABAIXO DE \$\3 MILHOES",
                                                    style: GoogleFonts.rajdhani(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: (_searchIndex == 7)
                                                          ? AppColors
                                                              .WHITE_COLOR
                                                          : AppColors
                                                              .ORANGE_COLOR,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  (_searchIndex == 7)
                                                      ? Text(
                                                          "",
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                (_searchIndex ==
                                                                        7)
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .orange,
                                                          ),
                                                        )
                                                      : Text(""),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _searchIndex = 8;
                                              });
                                              blocAtm.add(
                                                AtmFilterEvent(
                                                    atms: atms.value,
                                                    type: controlSearch,
                                                    indexSearch: _searchIndex),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              decoration: BoxDecoration(
                                                color: (_searchIndex == 8)
                                                    ? AppColors.RED_COLOR
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceTint,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .shadow
                                                        .withOpacity(.2),
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.wifi_off_rounded,
                                                    color: (_searchIndex == 8)
                                                        ? AppColors.WHITE_COLOR
                                                        : Colors.red,
                                                  ),
                                                  Text(
                                                    "OFFLINE",
                                                    style: GoogleFonts.rajdhani(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: (_searchIndex == 8)
                                                          ? AppColors
                                                              .WHITE_COLOR
                                                          : Colors.red,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  (_searchIndex == 8)
                                                      ? Text(
                                                          "",
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                (_searchIndex ==
                                                                        8)
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .red,
                                                          ),
                                                        )
                                                      : Text(""),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _searchIndex = 9;
                                              });
                                              blocAtm.add(
                                                AtmFilterEvent(
                                                    atms: atms.value,
                                                    type: controlSearch,
                                                    indexSearch: _searchIndex),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              decoration: BoxDecoration(
                                                color: (_searchIndex == 9)
                                                    ? Colors.green
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceTint,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .shadow
                                                        .withOpacity(.2),
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.check_box,
                                                    color: (_searchIndex == 9)
                                                        ? Colors.white
                                                        : Colors.green,
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      "COM PAPEL",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color:
                                                            (_searchIndex == 9)
                                                                ? Colors.white
                                                                : Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  (_searchIndex == 9)
                                                      ? Text(
                                                          "",
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                (_searchIndex ==
                                                                        9)
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .green,
                                                          ),
                                                        )
                                                      : Text(""),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _searchIndex = 10;
                                              });
                                              blocAtm.add(
                                                AtmFilterEvent(
                                                    atms: atms.value,
                                                    type: controlSearch,
                                                    indexSearch: _searchIndex),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              decoration: BoxDecoration(
                                                color: (_searchIndex == 10)
                                                    ? Colors.red
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceTint,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .shadow
                                                        .withOpacity(.2),
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .cancel_presentation_outlined,
                                                    color: (_searchIndex == 10)
                                                        ? Colors.white
                                                        : Colors.red,
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      "SEM PAPEL",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color:
                                                            (_searchIndex == 10)
                                                                ? Colors.white
                                                                : Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  (_searchIndex == 10)
                                                      ? Text(
                                                          "",
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                (_searchIndex ==
                                                                        10)
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .red,
                                                          ),
                                                        )
                                                      : Text(""),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _searchIndex = 11;
                                              });
                                              blocAtm.add(
                                                AtmFilterEvent(
                                                    atms: atms.value,
                                                    type: controlSearch,
                                                    indexSearch: _searchIndex),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              decoration: BoxDecoration(
                                                color: (_searchIndex == 11)
                                                    ? Colors.orange
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceTint,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .shadow
                                                        .withOpacity(.2),
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.warning_amber,
                                                    color: (_searchIndex == 11)
                                                        ? Colors.white
                                                        : Colors.orange,
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      "POUCO PAPEL",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color:
                                                            (_searchIndex == 11)
                                                                ? Colors.white
                                                                : Colors.orange,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  (_searchIndex == 11)
                                                      ? Text(
                                                          "",
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                (_searchIndex ==
                                                                        11)
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .orange,
                                                          ),
                                                        )
                                                      : Text(""),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: BlocBuilder<MapBloc, MapState>(
                                        builder: (context, state) {
                                          if (state is MapLoadingState) {
                                            return Center(
                                              child: Center(
                                                  child: Text("Carregando...")),
                                            );
                                          } else if (state is MapLoadedState) {
                                            // return Stack(
                                            //   children: [
                                            //     Positioned(
                                            //       top: 70,
                                            //       left: 20,
                                            //       right: 20,
                                            //       child: Container(
                                            //         height: 50,
                                            //         child: Row(
                                            //           mainAxisAlignment:
                                            //               MainAxisAlignment
                                            //                   .spaceBetween,
                                            //           children: [
                                            //             Container(
                                            //                 padding:
                                            //                     EdgeInsets
                                            //                         .all(8),
                                            //                 decoration:
                                            //                     BoxDecoration(
                                            //                   color: Colors
                                            //                       .white,
                                            //                   borderRadius:
                                            //                       BorderRadius
                                            //                           .circular(
                                            //                               50),
                                            //                   boxShadow: [
                                            //                     BoxShadow(
                                            //                       color: Colors
                                            //                           .black26
                                            //                           .withOpacity(
                                            //                               .3),
                                            //                       blurRadius:
                                            //                           2,
                                            //                       spreadRadius:
                                            //                           1,
                                            //                     ),
                                            //                   ],
                                            //                 ),
                                            //                 child: Icon(
                                            //                   Icons
                                            //                       .arrow_back_sharp,
                                            //                   size: 25,
                                            //                   color: AppColors
                                            //                       .MAIN_COLOR,
                                            //                 )),
                                            //             Expanded(
                                            //               child: Container(
                                            //                 width: 200,
                                            //                 child:
                                            //                     FlutterSlider(
                                            //                   values: [300],
                                            //                   max: 500,
                                            //                   min: 0,
                                            //                   onDragging: (handlerIndex,
                                            //                       lowerValue,
                                            //                       upperValue) {
                                            //                     print(
                                            //                         lowerValue);
                                            //                     print(
                                            //                         handlerIndex);
                                            //                     print(
                                            //                         upperValue);
                                            //                     // _lowerValue = lowerValue;
                                            //                     // _upperValue = upperValue;
                                            //                     setState(
                                            //                         () {});
                                            //                   },
                                            //                   trackBar:
                                            //                       FlutterSliderTrackBar(
                                            //                     inactiveTrackBar:
                                            //                         BoxDecoration(
                                            //                       borderRadius:
                                            //                           BorderRadius.circular(
                                            //                               20),
                                            //                       color: Colors
                                            //                           .black12,
                                            //                       border: Border.all(
                                            //                           width:
                                            //                               3,
                                            //                           color:
                                            //                               Colors.blue),
                                            //                     ),
                                            //                     activeTrackBar: BoxDecoration(
                                            //                         borderRadius:
                                            //                             BorderRadius.circular(
                                            //                                 4),
                                            //                         color: Colors
                                            //                             .blue
                                            //                             .withOpacity(0.5)),
                                            //                   ),
                                            //                 ),
                                            //               ),
                                            //             ),
                                            //             Container(
                                            //               decoration:
                                            //                   BoxDecoration(
                                            //                 color: Colors
                                            //                     .white,
                                            //                 borderRadius:
                                            //                     BorderRadius
                                            //                         .circular(
                                            //                             50),
                                            //                 boxShadow: [
                                            //                   BoxShadow(
                                            //                     color: Colors
                                            //                         .black26
                                            //                         .withOpacity(
                                            //                             .3),
                                            //                     blurRadius:
                                            //                         5,
                                            //                     spreadRadius:
                                            //                         1,
                                            //                   ),
                                            //                 ],
                                            //               ),
                                            //               child: Container(
                                            //                 padding:
                                            //                     EdgeInsets
                                            //                         .all(8),
                                            //                 child: Row(
                                            //                   children: [
                                            //                     SizedBox(
                                            //                       width: 10,
                                            //                     ),
                                            //                     Text(
                                            //                       "ATM",
                                            //                       style: GoogleFonts
                                            //                           .racingSansOne(
                                            //                         fontSize:
                                            //                             20,
                                            //                         color: AppColors
                                            //                             .MAIN_COLOR,
                                            //                       ),
                                            //                     ),
                                            //                     Icon(
                                            //                       Icons
                                            //                           .arrow_right,
                                            //                       size: 25,
                                            //                       color: AppColors
                                            //                           .MAIN_COLOR,
                                            //                     ),
                                            //                   ],
                                            //                 ),
                                            //               ),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // );
                                            return GoogleMap(
                                              onMapCreated: (GoogleMapController
                                                  controller) {
                                                mapController = controller;
                                                mapController
                                                    ?.setMapStyle(_mapStyle);
                                              },
                                              initialCameraPosition:
                                                  CameraPosition(
                                                target: LatLng(
                                                    -8.9039071, 13.1833099),
                                                zoom: 14,
                                              ),
                                              mapType: MapType.normal,
                                              myLocationEnabled: true,
                                              markers: state.markers,
                                              circles: {
                                                Circle(
                                                  circleId: CircleId("1"),
                                                  center: LatLng(
                                                    -8.9039071,
                                                    13.1833099,
                                                  ),
                                                  radius: 5000,
                                                  fillColor: Colors.blue
                                                      .withOpacity(0.1),
                                                  strokeWidth: 2,
                                                  strokeColor: Colors.blue,
                                                )
                                              },
                                            );
                                          }

                                          print(state);
                                          return Center(child: Text("data"));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return Container();
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      extendBody: true,
    );
  }
}

// BlocBuilder<MapBloc, MapState>(
//         builder: (context, state) {
//           if (state is MapLoadingState) {
//             return Center(
//               child: Center(child: Text("Carregando...")),
//             );
//           } else if (state is MapLoadedState) {
//             return Stack(
//               children: [
//                 SafeArea(
//                   child: GoogleMap(
//                     onMapCreated: (GoogleMapController controller) {
//                       mapController = controller;
//                       mapController?.setMapStyle(_mapStyle);
//                     },
//                     initialCameraPosition: CameraPosition(
//                       target: LatLng(-8.9039071, 13.1833099),
//                       zoom: 14,
//                     ),
//                     mapType: MapType.normal,
//                     myLocationEnabled: true,
//                     markers: state.markers,
//                     circles: {
//                       Circle(
//                         circleId: CircleId("1"),
//                         center: LatLng(
//                           -8.9039071,
//                           13.1833099,
//                         ),
//                         radius: 5000,
//                         fillColor: Colors.blue.withOpacity(0.1),
//                         strokeWidth: 2,
//                         strokeColor: Colors.blue,
//                       )
//                     },
//                   ),
//                 ),
//                 Positioned(
//                   top: 70,
//                   left: 20,
//                   right: 20,
//                   child: Container(
//                     height: 50,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                             padding: EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(50),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black26.withOpacity(.3),
//                                   blurRadius: 2,
//                                   spreadRadius: 1,
//                                 ),
//                               ],
//                             ),
//                             child: Icon(
//                               Icons.arrow_back_sharp,
//                               size: 25,
//                               color: AppColors.MAIN_COLOR,
//                             )),
//                         Expanded(
//                           child: Container(
//                             width: 200,
//                             child: FlutterSlider(
//                               values: [300],
//                               max: 500,
//                               min: 0,
//                               onDragging:
//                                   (handlerIndex, lowerValue, upperValue) {
//                                 print(lowerValue);
//                                 print(handlerIndex);
//                                 print(upperValue);
//                                 // _lowerValue = lowerValue;
//                                 // _upperValue = upperValue;
//                                 setState(() {});
//                               },
//                               trackBar: FlutterSliderTrackBar(
//                                 inactiveTrackBar: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20),
//                                   color: Colors.black12,
//                                   border:
//                                       Border.all(width: 3, color: Colors.blue),
//                                 ),
//                                 activeTrackBar: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(4),
//                                     color: Colors.blue.withOpacity(0.5)),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(50),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black26.withOpacity(.3),
//                                 blurRadius: 5,
//                                 spreadRadius: 1,
//                               ),
//                             ],
//                           ),
//                           child: Container(
//                             padding: EdgeInsets.all(8),
//                             child: Row(
//                               children: [
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text(
//                                   "ATM",
//                                   style: GoogleFonts.racingSansOne(
//                                     fontSize: 20,
//                                     color: AppColors.MAIN_COLOR,
//                                   ),
//                                 ),
//                                 Icon(
//                                   Icons.arrow_right,
//                                   size: 25,
//                                   color: AppColors.MAIN_COLOR,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }

//           print(state);
//           return Center(child: Text("data"));
//         },
//       ),
