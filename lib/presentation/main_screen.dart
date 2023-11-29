import 'dart:async';
import 'dart:ui';

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:maxalert/bloc/theme/theme_bloc.dart';
import 'package:maxalert/bloc/theme/theme_event.dart';
import 'package:maxalert/bloc/theme/theme_state.dart';
import 'package:maxalert/presentation/screens/atm/atm_screen.dart';
import 'package:maxalert/presentation/screens/map/map_screen.dart';
import 'package:maxalert/presentation/screens/mda/mda_screen.dart';
import 'package:maxalert/utils/app_colors.dart';
import 'package:maxalert/utils/app_icons.dart';

import 'package:local_auth/error_codes.dart' as auth_error;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _isMenuOpen = false;
  int _type = 0;

  FlutterSecureStorage storage = FlutterSecureStorage();

  ValueNotifier<bool> callBiometric = ValueNotifier<bool>(false);

  ValueNotifier<int> segundosRestantes = ValueNotifier<int>(0);

  String? themeStorage;
  void iniStorage() async {
    themeStorage = await storage.read(key: "theme_preference");
  }

  final List<Widget> _pages = [
    AtmScreen(type: 0),
    MdaScreen(),
  ];

  @override
  void initState() {
    super.initState();
    iniStorage();
  }

  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          Scaffold(
            extendBody: true,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                Get.to(MapScreen());
              },
              child: SvgPicture.asset(
                AppIcons.MAP,
                width: 50,
              ),
            ),
            // floatingActionButton: (themeBloc.state is ThemeLightState)
            //     ? FloatingActionButton(
            //         backgroundColor: Theme.of(context).colorScheme.secondary,
            //         onPressed: () {
            //           BlocProvider.of<ThemeBloc>(context)
            //               .add(ToggleDarkTheme());

            //           //   if (_isMenuOpen == true) {
            //           //     setState(() {
            //           //       _isMenuOpen = false;
            //           //     });
            //           //   } else {
            //           //     setState(() {
            //           //       _isMenuOpen = true;
            //           //     });
            //           //   }
            //         },
            //         child: Icon(
            //           Icons.dark_mode_rounded,
            //           color: Colors.white.withOpacity(.6),
            //         ),
            //       )
            //     : FloatingActionButton(
            //         backgroundColor: Theme.of(context).colorScheme.secondary,
            //         onPressed: () {
            //           BlocProvider.of<ThemeBloc>(context)
            //               .add(ToggleLightTheme());

            //           //   if (_isMenuOpen == true) {
            //           //     setState(() {
            //           //       _isMenuOpen = false;
            //           //     });
            //           //   } else {
            //           //     setState(() {
            //           //       _isMenuOpen = true;
            //           //     });
            //           //   }
            //         },
            //         child: Icon(
            //           Icons.light_mode,
            //           color: Colors.white.withOpacity(.6),
            //         ),
            //       ),

            bottomNavigationBar: Container(
              height: 50,
              child: BottomAppBar(
                shape: CircularNotchedRectangle(),
                clipBehavior: Clip.antiAlias,
                notchMargin: 8.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  child: IconTheme(
                    data: IconThemeData(color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _currentIndex = 0;
                            });
                          },
                          child: Container(
                            width: 150,
                            child: Column(
                              children: [
                                Expanded(
                                  child: SvgPicture.asset(
                                    width: 20,
                                    color: (_currentIndex == 0)
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onTertiary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onTertiary
                                            .withOpacity(.4),
                                    AppIcons.ATM,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                          child: Container(
                            width: 150,
                            child: Column(
                              children: [
                                Expanded(
                                  child: SvgPicture.asset(
                                    width: 20,
                                    AppIcons.MDA,
                                    color: (_currentIndex == 1)
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onTertiary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onTertiary
                                            .withOpacity(.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            body: Stack(
              children: [
                _pages[_currentIndex],
                // (_isMenuOpen == true)
                //     ? Positioned(
                //         top: 0,
                //         bottom: 0,
                //         left: 0,
                //         right: 0,
                //         child: BackdropFilter(
                //           filter: ImageFilter.blur(
                //             sigmaX: 6.0,
                //             sigmaY: 6.0,
                //           ),
                //           child: AnimatedSizeAndFade(
                //             child: (_isMenuOpen)
                //                 ? Container(
                //                     padding: EdgeInsets.only(bottom: 80),
                //                     width:
                //                         MediaQuery.of(context).size.width,
                //                     //color: Colors.white.withOpacity(.5),
                //                     decoration: BoxDecoration(
                //                       gradient: LinearGradient(
                //                         begin: Alignment.topCenter,
                //                         end: Alignment.bottomCenter,
                //                         colors: [
                //                           Colors.white.withOpacity(.1),
                //                           Colors.white
                //                         ],
                //                       ),
                //                     ),
                //                     child: Center(
                //                       child: Column(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.end,
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.center,
                //                         children: [
                //                           InkWell(
                //                             onTap: () {},
                //                             child: Container(
                //                               padding: EdgeInsets.all(10),
                //                               child: Row(
                //                                 mainAxisAlignment:
                //                                     MainAxisAlignment
                //                                         .center,
                //                                 children: [
                //                                   Text(
                //                                     "ATMs TODOS",
                //                                     style: GoogleFonts
                //                                         .rajdhani(
                //                                       fontSize: 20,
                //                                       fontWeight:
                //                                           FontWeight.w900,
                //                                       color: AppColors
                //                                           .MAIN_COLOR,
                //                                     ),
                //                                   ),
                //                                 ],
                //                               ),
                //                             ),
                //                           ),
                //                           Container(
                //                             padding: EdgeInsets.all(10),
                //                             child: Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment.center,
                //                               children: [
                //                                 Text(
                //                                   "ATM CENTER",
                //                                   style:
                //                                       GoogleFonts.rajdhani(
                //                                     fontSize: 20,
                //                                     fontWeight:
                //                                         FontWeight.w900,
                //                                     color: AppColors
                //                                         .MAIN_COLOR,
                //                                   ),
                //                                 ),
                //                               ],
                //                             ),
                //                           ),
                //                           Container(
                //                             padding: EdgeInsets.all(10),
                //                             child: Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment.center,
                //                               children: [
                //                                 Text(
                //                                   "ATM REMOTO",
                //                                   style:
                //                                       GoogleFonts.rajdhani(
                //                                     fontSize: 20,
                //                                     fontWeight:
                //                                         FontWeight.w900,
                //                                   ),
                //                                 ),
                //                               ],
                //                             ),
                //                           ),
                //                           Container(
                //                             padding: EdgeInsets.all(10),
                //                             child: Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment.center,
                //                               children: [
                //                                 Text(
                //                                   "ATM BALCÃO",
                //                                   style:
                //                                       GoogleFonts.rajdhani(
                //                                     fontSize: 20,
                //                                     fontWeight:
                //                                         FontWeight.w900,
                //                                   ),
                //                                 ),
                //                               ],
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                   )
                //                 : Container(),
                //           ),
                //         ),
                //       )
                //     : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
