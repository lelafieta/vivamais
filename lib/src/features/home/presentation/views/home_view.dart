import 'package:animate_do/animate_do.dart';
import 'package:awesome_place_search/awesome_place_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:vivamais/src/core/resources/app_icons.dart';
import 'package:vivamais/src/core/resources/app_images.dart';
import 'package:vivamais/src/core/utils/app_values.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vivamais/src/features/blood/presentation/cubit/blood_cubit.dart';
import 'package:vivamais/src/features/blood/presentation/cubit/blood_state.dart';
import 'package:vivamais/src/features/home/presentation/views/widgets/blood_skeleton_widget.dart';

import '../../../../config/routes/routes.dart';
import '../../../../config/theme/color_palette.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String ex1 = "No value selected";
  Widget bloodIcon = Icon(FontAwesomeIcons.tint);
  TextEditingController blood = TextEditingController();
  LatLng? _currentPosition;
  String _locationMessage = "None";
  String get apiKey => dotenv.env['ANDROID_GOOGLE_API_KEY'] ?? '';
  TextEditingController controller = TextEditingController();
  TextEditingController locationHospital = TextEditingController();
  PredictionModel? prediction;

  List<String> bloods = [
    "A+",
    "B+",
    "AB-",
    "A-",
    "O-",
    "AB+",
    "O+",
    "B-",
  ];

  void bloodSvg(String blood) {
    switch (blood) {
      case "A+":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.ap,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
        break;

      case "B+":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.bp,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
        break;
      case "AB-":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.abn,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
        break;
      case "A-":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.an,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
        break;
      case "O-":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.oN,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
      case "AB+":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.ab,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
      case "O+":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.op,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
      case "B-":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.b,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
      default:
        setState(() {
          bloodIcon = Icon(
            FontAwesomeIcons.tint,
            color: AppColors.primaryColor,
          );
        });
    }
  }

  Widget svgBlood(String blood) {
    switch (blood) {
      case "A+":
        return SvgPicture.asset(
          AppIcons.ap,
          color: AppColors.primaryColor,
        );

      case "B+":
        return SvgPicture.asset(
          AppIcons.bp,
          color: AppColors.primaryColor,
        );
      case "AB-":
        return SvgPicture.asset(
          AppIcons.abn,
          color: AppColors.primaryColor,
        );
      case "A-":
        return SvgPicture.asset(
          AppIcons.an,
          color: AppColors.primaryColor,
        );
      case "O-":
        return SvgPicture.asset(
          AppIcons.oN,
          color: AppColors.primaryColor,
        );
      case "AB+":
        return SvgPicture.asset(
          AppIcons.ab,
          color: AppColors.primaryColor,
        );
      case "O+":
        return SvgPicture.asset(
          AppIcons.op,
          color: AppColors.primaryColor,
        );
      case "B-":
        return SvgPicture.asset(
          AppIcons.b,
          color: AppColors.primaryColor,
        );
      default:
        return Icon(
          FontAwesomeIcons.tint,
          color: AppColors.primaryColor,
        );
    }
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // As permissões foram negadas
        return Future.error('Localização negada');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // As permissões foram negadas para sempre, exiba uma mensagem ao usuário
      return Future.error('Localização negada para sempre');
    }
    print("OLA");
    _updateLocation();
  }

  Future<void> _getCurrentLocation() async {
    _checkLocationPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _currentPosition = LatLng(position.latitude, position.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      String address = '${place.street}, ${place.locality}, ${place.country}';
      print(address);
      _locationMessage = address;
      // location.value = address;
    }
    setState(() {});
  }

  void _searchPlaces() {
    AwesomePlaceSearch(
      context: context,
      apiKey: apiKey,
      countries: ["ao"],
      errorText: "Ouve um erro, tente novamente mais tarde",
      hint: "Pesquise um Localização/Hospital",
      dividerItemColor: Colors.grey.withOpacity(.5),
      dividerItemWidth: .5,
      elevation: 5,
      indicatorColor: Colors.blue,
      modalBorderRadius: 50.0,
      onTap: (value) async {
        final result = await value;

        setState(() {
          locationHospital.text = result.description!;
          prediction = result;
        });
      },
    ).show();
  }

  Future<void> _updateLocation() async {
    Geolocator.getPositionStream().listen((Position position) async {
      _currentPosition = LatLng(position.latitude, position.longitude);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = '${place.street}, ${place.locality}, ${place.country}';
        _locationMessage = address;
        // location.value = address;
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          toolbarHeight: 80,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Olá! Lingard.",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 16,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: StreamBuilder<Object>(
                        stream: Geolocator.getPositionStream(),
                        builder: (context, snapshot) {
                          return Text(
                            "${_locationMessage}",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: AppColors.secondaryTextColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          );
                        }),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.primaryColor,
                  )
                ],
              )
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(AppIcons.notification),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   width: double.infinity,
                //   height: AppSize.s140,
                //   child: Stack(
                //     children: [
                //       Positioned(
                //         bottom: 0,
                //         right: 0,
                //         left: 0,
                //         child: Container(
                //           width: double.infinity,
                //           height: AppSize.s120,
                //           decoration: BoxDecoration(
                //             color: AppColors.primaryColor,
                //             borderRadius: BorderRadius.circular(AppSize.s14),
                //           ),
                //         ),
                //       ),
                //       Positioned(
                //         top: -50,
                //         right: -AppSize.s10,
                //         child: SvgPicture.asset(
                //           AppSvg.onBoarding2,
                //           width: AppSize.s200,
                //         ),
                //       ),
                //       Container(
                //         padding: EdgeInsets.all(10),
                //         child: Row(
                //           children: [
                //             Expanded(
                //               flex: 2,
                //               child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   SizedBox(
                //                     height: 20,
                //                   ),
                //                   Text(
                //                     "Estas qualificado para doar?",
                //                     style: TextStyle(
                //                       fontSize: 16,
                //                       fontWeight: FontWeight.w600,
                //                       color: Colors.white,
                //                     ),
                //                   ),
                //                   TextButton(
                //                     style: ButtonStyle(
                //                       backgroundColor: MaterialStatePropertyAll(
                //                         Colors.white,
                //                       ),
                //                       minimumSize: MaterialStatePropertyAll(
                //                         Size(10, 0),
                //                       ),
                //                     ),
                //                     onPressed: () {},
                //                     child: Text(
                //                       "Revise os Termos e Condições",
                //                       style: TextStyle(
                //                         fontSize: 12,
                //                         color: Colors.black87,
                //                       ),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //             Expanded(
                //               child: SizedBox.shrink(),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: AppMargin.m16),
                  child: Text(
                    "Estás a procura de sangue?",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: AppSize.s20,
                ),

                // FormBuilderDropdown<String>(
                //   name: 'blood',
                //   autovalidateMode: AutovalidateMode.onUserInteraction,
                //   decoration: InputDecoration(
                //     hintText: 'Selecionar Grupo Snguíneo',
                //     suffixIcon: bloodIcon,
                //   ),
                //   validator: FormBuilderValidators.compose([
                //     FormBuilderValidators.required(
                //         errorText: "Grupo Sanguíneo obrigatório"),
                //   ]),
                //   items: bloods.map((bloodGroup) {
                //     return DropdownMenuItem(
                //       value: bloodGroup,
                //       child: Text(bloodGroup),
                //     );
                //   }).toList(),
                //   onChanged: (groupBlood) {
                //     svgBlood(groupBlood!);
                //     blood.text = groupBlood;
                //   },
                // ),
                // GooglePlaceAutoCompleteTextField(
                //   textEditingController: controller,
                //   googleAPIKey: apiKey,
                //   language: "pt",
                //   boxDecoration: BoxDecoration(
                //     border: Border(),
                //     borderRadius: BorderRadius.circular(50),
                //     color: Colors.white,
                //     boxShadow: const [
                //       BoxShadow(
                //         color: Colors.black26,
                //         spreadRadius: 1,
                //         blurRadius: 5,
                //         offset: Offset(1, 2),
                //       )
                //     ],
                //   ),

                //   inputDecoration: InputDecoration(
                //     prefixIcon: Container(
                //       padding: const EdgeInsets.all(14),
                //       child: SvgPicture.asset(
                //         "assets/images/marker.svg",
                //       ),
                //     ),
                //     hintText: "Pesquisar local com ATM",
                //     filled: true,
                //     fillColor: Colors.white,
                //     border: InputBorder.none,
                //     enabledBorder: OutlineInputBorder(
                //       borderSide: const BorderSide(
                //         color: Colors.white,
                //         width: 0,
                //       ),
                //       borderRadius: BorderRadius.circular(50),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderSide: const BorderSide(
                //         color: Colors.white,
                //         width: 0,
                //       ),
                //       borderRadius: BorderRadius.circular(50),
                //     ),
                //     contentPadding: const EdgeInsets.symmetric(vertical: 8),
                //   ),

                //   debounceTime: 200,
                //   countries: const [
                //     "ao",
                //   ],
                //   isLatLngRequired: true,
                //   getPlaceDetailWithLatLng: (Prediction prediction) {
                //     final location = LatLng(
                //       double.parse(prediction.lat.toString()),
                //       double.parse(prediction.lng.toString()),
                //     );
                //     // setState(() {
                //     //   searchedLocation = location;
                //     // });
                //     // mapController?.animateCamera(
                //     //   CameraUpdate.newLatLngZoom(location, 15.0),
                //     // );
                //   }, // this callback is called when isLatLngRequired is true
                //   itemClick: (Prediction prediction) {
                //     controller.text = prediction.description!;
                //     controller.selection = TextSelection.fromPosition(
                //       TextPosition(
                //         offset: prediction.description!.length,
                //       ),
                //     );
                //   },
                //   // if we want to make custom list item builder
                //   itemBuilder: (context, index, Prediction prediction) {
                //     return Container(
                //       padding: const EdgeInsets.all(10),
                //       child: Row(
                //         children: [
                //           const Icon(Icons.location_on),
                //           const SizedBox(
                //             width: 7,
                //           ),
                //           Expanded(
                //             child: Text(
                //               "${prediction.description ?? ""}",
                //             ),
                //           )
                //         ],
                //       ),
                //     );
                //   },
                //   // if you want to add seperator between list items
                //   seperatedBuilder: const Divider(),
                //   // want to show close icon
                //   isCrossBtnShown: true,
                //   // optional container padding
                //   //containerHorizontalPadding: 10,
                //   // place type
                //   placeType: PlaceType.geocode,
                // ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: AppMargin.m15),
                  child: TextFormField(
                    controller: locationHospital,
                    onTap: () {
                      _searchPlaces();
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: AppSize.s25),
                      hintText: 'Selecionar Localização/Hospital',
                      suffixIcon: Icon(Icons.location_on_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: AppSize.s12,
                ),

                BlocBuilder<BloodCubit, BloodState>(
                  builder: (context, state) {
                    if (state is BloodLoading) {
                      return Text("Buscando os grupos sanguíneos");
                    } else if (state is BloodLoaded) {
                      final bloods = state.bloods;
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: AppMargin.m15),
                        child: DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            hintText: 'Selecionar Grupo Snguíneo',
                            suffixIcon: bloodIcon,
                          ),
                          hint: const Text(
                            'Selecionar Grupo Snguíneo',
                            style: TextStyle(fontSize: 14),
                          ),
                          items: bloods
                              .map((item) => DropdownMenuItem<String>(
                                    value: item.type,
                                    child: Text(
                                      item.type,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select gender.';
                            }
                            return null;
                          },
                          onChanged: (groupBlood) {
                            bloodSvg(groupBlood!);
                            blood.text = groupBlood;
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 24,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      );
                    } else if (state is BloodFailure) {
                      return Text("Error");
                    }
                    return SizedBox.shrink();
                  },
                ),
                SizedBox(
                  height: AppSize.s12,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: AppMargin.m15),
                  child: ElevatedButton(
                      onPressed: () {
                        if (blood.text != "" && prediction != null) {
                          Get.toNamed(Routes.createRequestRoute, arguments: {
                            "blood": blood.text,
                            "prediction": prediction
                          });
                        }

                        // Navigator.of(context).pushNamed(
                        //   Routes.createRequestRoute,

                        // );
                      },
                      child: Text("Enviar Pedido")),
                ),
                SizedBox(
                  height: AppSize.s30,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: AppMargin.m16),
                  width: double.infinity,
                  height: 120,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.postRoute);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: AppColors.strokeColor,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.request,
                                  width: 55,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                    "Post Pedido Doador",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(Routes.bankBloodRoute);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: AppColors.strokeColor,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.bloodBank,
                                  width: 55,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                    "Banco de Sangue",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.donorRoute);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: AppColors.strokeColor,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.emergency,
                                  width: 55,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                    "Doador Emergente",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: AppSize.s16,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: AppMargin.m10),
                  width: double.infinity,
                  // decoration: BoxDecoration(
                  //   border: Border.all(
                  //     width: 1,
                  //     color: AppColors.strokeColor,
                  //   ),
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: AppMargin.m15),
                        child: Text(
                          "Grupo Sanguíneos",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      SizedBox(
                        height: AppSize.s12,
                      ),
                      Container(
                        width: double.infinity,
                        height: 80,
                        child: BlocBuilder<BloodCubit, BloodState>(
                          builder: (context, state) {
                            if (state is BloodLoading) {
                              return BloodSkeletonWidget();
                            } else if (state is BloodLoaded) {
                              final bloods = state.bloods;
                              return ListView.separated(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.only(left: AppMargin.m15),
                                itemBuilder: (context, index) {
                                  final blood = bloods.elementAt(index);
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      svgBlood(blood.type),
                                      Text(
                                        "${blood.percentage}%",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 15,
                                  );
                                },
                                itemCount: bloods.length,
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           SvgPicture.asset(
                      //             AppIcons.ap,
                      //             color: AppColors.primaryColor,
                      //           ),
                      //           Text(
                      //             "10%",
                      //             style: TextStyle(
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           SvgPicture.asset(
                      //             AppIcons.bp,
                      //             color: AppColors.primaryColor,
                      //           ),
                      //           Text(
                      //             "5%",
                      //             style: TextStyle(
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           SvgPicture.asset(
                      //             AppIcons.abn,
                      //             color: AppColors.primaryColor,
                      //           ),
                      //           Text(
                      //             "7%",
                      //             style: TextStyle(
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           SvgPicture.asset(
                      //             AppIcons.an,
                      //             color: AppColors.primaryColor,
                      //           ),
                      //           Text(
                      //             "90%",
                      //             style: TextStyle(
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           SvgPicture.asset(
                      //             AppIcons.oN,
                      //             color: AppColors.primaryColor,
                      //           ),
                      //           Text(
                      //             "6%",
                      //             style: TextStyle(
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           SvgPicture.asset(
                      //             AppIcons.bp,
                      //             color: AppColors.primaryColor,
                      //           ),
                      //           Text(
                      //             "6%",
                      //             style: TextStyle(
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           SvgPicture.asset(
                      //             AppIcons.op,
                      //             color: AppColors.primaryColor,
                      //           ),
                      //           Text(
                      //             "6%",
                      //             style: TextStyle(
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           SvgPicture.asset(
                      //             AppIcons.ab,
                      //             color: AppColors.primaryColor,
                      //           ),
                      //           Text(
                      //             "6%",
                      //             style: TextStyle(
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: AppMargin.m16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mapa da Jornada de Sangue",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "Ver Mais",
                        style: TextStyle(color: AppColors.secondaryTextColor),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.all(AppPadding.p20),
                  margin: EdgeInsets.symmetric(horizontal: AppMargin.m16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.strokeColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color: Colors.black12,
                                      width: 100,
                                      height: 100,
                                      child: Center(
                                        child: Text("MAPA"),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppIcons.user2,
                                            width: 18,
                                            color: AppColors.secondaryTextColor,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Azancot Menezes",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppIcons.location,
                                            width: 18,
                                            color: AppColors.secondaryTextColor,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Azancot Menezes",
                                            style: TextStyle(
                                              color:
                                                  AppColors.secondaryTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.hourglass_bottom,
                                            color: AppColors.secondaryTextColor,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "10:20, Abril 2024",
                                            style: TextStyle(
                                              color:
                                                  AppColors.secondaryTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Tempo restante para doação",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "02:30:01",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryColor),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: AppMargin.m16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pedido de Doação",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "Ver Mais",
                        style: TextStyle(color: AppColors.secondaryTextColor),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.all(AppPadding.p20),
                  margin: EdgeInsets.symmetric(horizontal: AppMargin.m16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.strokeColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.red,
                                    child: Image.asset(
                                      AppImages.profile,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Ana Martins",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons.location,
                                          width: 18,
                                          color: AppColors.secondaryTextColor,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Azancot Menezes",
                                          style: TextStyle(
                                            color: AppColors.secondaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.hourglass_bottom,
                                          color: AppColors.secondaryTextColor,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "10:20, Abril 2024",
                                          style: TextStyle(
                                            color: AppColors.secondaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: SvgPicture.asset(
                              AppIcons.an,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: AppColors.strokeColor,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Negar",
                            style: TextStyle(
                              color: AppColors.secondaryColor,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: AppColors.strokeColor,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.donateAcceptRoute);
                            },
                            child: Text(
                              "Doar Agora",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
