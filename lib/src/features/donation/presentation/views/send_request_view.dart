// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';

// class SendRequestView extends StatelessWidget {
//   const SearchResultView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FadeInUp(
//         child: Scaffold(
//           body: Text("data"),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:vivamais/src/config/theme/color_palette.dart';
import 'package:vivamais/src/core/resources/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:interactive_bottom_sheet/interactive_bottom_sheet.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../../core/resources/app_icons.dart';
import '../../../../core/resources/app_images.dart';
import '../../../../core/utils/app_values.dart';

class SendRequestView extends StatefulWidget {
  @override
  _SendRequestViewState createState() => _SendRequestViewState();
}

class _SendRequestViewState extends State<SendRequestView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  GoogleMapController? mapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-8.873574, 13.254656),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      bottomSheet: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
          ),
          child: Container(
            padding: EdgeInsets.all(AppPadding.p16),
            height: 250,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    child: Image.asset(
                                      AppImages.profile,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.star,
                                    color: Colors.orange,
                                    width: 16,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "5.0",
                                    style: TextStyle(
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ana Martins",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                "Luanda, Cazenga (0.7 km)",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Última Doação 29 Dez 2024",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: SvgPicture.asset(
                        AppIcons.bp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset(
                            AppImages.saveLife2,
                            width: 35,
                          ),
                          Text(
                            "6 Vidas Salvas",
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset(
                            AppImages.rate,
                            width: 35,
                          ),
                          Text(
                            "Boa Avaliação",
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset(
                            AppImages.behavior,
                            width: 35,
                          ),
                          Text(
                            "Bao Atuação.",
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSize.s16,
                ),
                ElevatedButton(
                  onPressed: () {
                    Alert(
                      context: context,
                      desc: "Pedido enviado com sucesso.",
                      image: SvgPicture.asset(
                        AppSvg.success,
                        width: 200,
                      ),
                      buttons: [
                        DialogButton(
                          color: AppColors.primaryColor,
                          child: Text(
                            "Fechar",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {},
                        ),
                      ],
                      style: AlertStyle(
                        backgroundColor: AppColors.whiteColor,
                        descStyle: Theme.of(context).textTheme.bodySmall!,
                        buttonAreaPadding: EdgeInsets.all(10),
                      ),
                    ).show();
                  },
                  child: Text("Enviar Pedido"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
