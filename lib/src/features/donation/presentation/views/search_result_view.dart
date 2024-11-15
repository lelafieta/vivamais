// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';

// class SearchResultView extends StatelessWidget {
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

import 'package:sheet/sheet.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:vivamais/src/config/theme/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:interactive_bottom_sheet/interactive_bottom_sheet.dart';

import '../../../../config/routes/routes.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/resources/app_images.dart';
import '../../../../core/utils/app_values.dart';

class SearchResultView extends StatefulWidget {
  @override
  _SearchResultViewState createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<SearchResultView> {
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

  final ScrollController listViewController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: SnappingSheet(
    //     child: Text("TEXT"),
    //     lockOverflowDrag: true,
    //     snappingPositions: [
    //       SnappingPosition.factor(
    //         positionFactor: 0.1,
    //         snappingCurve: Curves.easeOutExpo,
    //         snappingDuration: Duration(seconds: 1),
    //         grabbingContentOffset: GrabbingContentOffset.top,
    //       ),
    //       SnappingPosition.factor(
    //         snappingCurve: Curves.elasticOut,
    //         snappingDuration: Duration(milliseconds: 1750),
    //         positionFactor: 0.5,
    //       ),
    //       SnappingPosition.factor(
    //         grabbingContentOffset: GrabbingContentOffset.bottom,
    //         snappingCurve: Curves.easeInExpo,
    //         snappingDuration: Duration(seconds: 1),
    //         positionFactor: 0.9,
    //       ),
    //     ],
    //     grabbing: Container(
    //       color: Colors.red,
    //     ),
    //     grabbingHeight: 20,
    //     sheetAbove: null,
    //     sheetBelow: SnappingSheetContent(
    //       draggable: true,
    //       childScrollController: listViewController,
    //       child: Container(
    //         color: Colors.white,
    //         child: ListView.builder(
    //           controller: listViewController,
    //           itemBuilder: (context, index) {
    //             return Container(
    //               margin: EdgeInsets.all(15),
    //               color: Colors.green[200],
    //               height: 100,
    //               child: Center(
    //                 child: Text(index.toString()),
    //               ),
    //             );
    //           },
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      bottomSheet: InteractiveBottomSheet(
        options: InteractiveBottomSheetOptions(
          maxSize: 0.75,
          backgroundColor: Colors.white,
          snapList: [0.25, 0.5],
        ),
        draggableAreaOptions: DraggableAreaOptions(
          topBorderRadius: 10,
          height: 40,
          backgroundColor: Colors.white,
          indicatorColor: AppColors.strokeColor,
          indicatorWidth: 50,
          indicatorHeight: 8,
          indicatorRadius: 10,
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.sendRequestRoute);
                  },
                  child: Container(
                    padding: EdgeInsets.all(AppPadding.p16),
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
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            child: Image.asset(
                                              AppImages.profile,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            child: SvgPicture.asset(
                                              AppIcons.crown,
                                              width: 14,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Ana Martins",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      Text(
                                        "0.7 km",
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
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.all(AppPadding.p16),
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
                                  child: Stack(
                                    children: [
                                      ClipRRect(
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
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          child: SvgPicture.asset(
                                            AppIcons.crown,
                                            width: 14,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      )
                                    ],
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
                                    Text(
                                      "0.7 km",
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
                    ],
                  ),
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
