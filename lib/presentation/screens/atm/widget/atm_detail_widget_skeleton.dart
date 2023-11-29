import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maxalert/utils/app_icons.dart';

class AtmDetailWidgetSkeleton extends StatelessWidget {
  const AtmDetailWidgetSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  color: Theme.of(context).colorScheme.onPrimary,
                  child: Column(
                    children: [
                      InkWell(
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              width: 25,
                              color: Theme.of(context).colorScheme.outline,
                              AppIcons.MAPA_LOCAL,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width - 40,
                                height: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            width: 25,
                            color: Theme.of(context).colorScheme.outline,
                            AppIcons.BANK,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 40,
                              height: 20,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            width: 25,
                            color: Theme.of(context).colorScheme.outline,
                            AppIcons.ATM,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 40,
                              height: 20,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.secondary,
                  child: Divider(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(.5),
                    thickness: 5,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  color: Theme.of(context).colorScheme.secondary,
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 14,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    height: 20,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.settings_applications_sharp,
                                    size: 14,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    height: 20,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.key,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    size: 14,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.rajdhani(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        fontSize: 10,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'ID: ',
                                        ),
                                        TextSpan(
                                          text: 'dfkmdfmfdkf',
                                          style: GoogleFonts.rajdhani(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer
                                  .withOpacity(.8),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 10, left: 10),
                                      child: Text(
                                        "MONTANTE ACTUAL",
                                        style: GoogleFonts.rajdhani(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "AOA.",
                                          style: GoogleFonts.rampartOne(
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "1.246.700",
                                          style: GoogleFonts.rammettoOne(
                                            fontSize: 30,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            textStyle: TextStyle(
                                              shadows: [
                                                Shadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .shadow
                                                      .withOpacity(.8),
                                                  offset: Offset(2, 2),
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: -5,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "ATM",
                                  style: GoogleFonts.rajdhani(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Material(
                  elevation: 4,
                  child: Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.secondary,
                    padding: EdgeInsets.only(bottom: 0),
                    child: Container(
                      width: double.infinity,
                      height: 5,
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(.5),
                      padding: EdgeInsets.only(bottom: 0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Flexible(
          //   child: Container(
          //     child: Column(
          //       children: [
          //         Container(
          //           padding: EdgeInsets.only(
          //               left: 10, right: 10, top: 10),
          //           child: Row(
          //             mainAxisAlignment:
          //                 MainAxisAlignment.spaceBetween,
          //             children: [
          //               InkWell(
          //                ,
          //                 child: Container(
          //                   height: 30,
          //                   decoration: BoxDecoration(
          //                     border: Border(
          //                       bottom: BorderSide(
          //                         color: (index == 0)
          //                             ? Theme.of(context)
          //                                 .colorScheme
          //                                 .outlineVariant
          //                             : color1,
          //                         width: 2.0,
          //                       ),
          //                     ),
          //                   ),
          //                   child: Row(
          //                     children: [
          //                       Icon(
          //                         Icons.swap_horiz_outlined,
          //                         color: (index == 0)
          //                             ? Theme.of(context)
          //                                 .colorScheme
          //                                 .outlineVariant
          //                             : color0,
          //                         size: 16,
          //                       ),
          //                       SizedBox(
          //                         width: 5,
          //                       ),
          //                       Text(
          //                         "TRANSAÇÕES",
          //                         style: GoogleFonts.rajdhani(
          //                           color: (index == 0)
          //                               ? Theme.of(context)
          //                                   .colorScheme
          //                                   .outlineVariant
          //                               : color1,
          //                           fontWeight: FontWeight.bold,
          //                           fontSize: 12,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //               InkWell(
          //                 onTap: () {
          //                   setState(() {
          //                     color0 = Theme.of(context)
          //                         .colorScheme
          //                         .onPrimary;
          //                     color1 = Theme.of(context)
          //                         .colorScheme
          //                         .error;
          //                     color2 = Theme.of(context)
          //                         .colorScheme
          //                         .onPrimary;
          //                     underline = color1;
          //                     index = 1;
          //                   });
          //                 },
          //                 child: Container(
          //                   height: 30,
          //                   decoration: BoxDecoration(
          //                     border: Border(
          //                       bottom: BorderSide(
          //                         color: (index == 1)
          //                             ? Theme.of(context)
          //                                 .colorScheme
          //                                 .error
          //                             : color1,
          //                         width: 2.0,
          //                       ),
          //                     ),
          //                   ),
          //                   child: Row(
          //                     children: [
          //                       Icon(
          //                         Icons.warning_amber_rounded,
          //                         color: (index == 1)
          //                             ? Theme.of(context)
          //                                 .colorScheme
          //                                 .error
          //                             : color1,
          //                         size: 16,
          //                       ),
          //                       SizedBox(
          //                         width: 5,
          //                       ),
          //                       Text(
          //                         "ALERTAS",
          //                         style: GoogleFonts.rajdhani(
          //                           color: (index == 1)
          //                               ? Theme.of(context)
          //                                   .colorScheme
          //                                   .error
          //                               : color1,
          //                           fontWeight: FontWeight.bold,
          //                           fontSize: 12,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //               InkWell(
          //                 onTap: () {

          //                 },
          //                 child: Container(
          //                   height: 30,
          //                   decoration: BoxDecoration(
          //                     border: Border(
          //                       bottom: BorderSide(
          //                         color: (index == 2)
          //                             ? Theme.of(context)
          //                                 .colorScheme
          //                                 .primary
          //                             : color2,
          //                         width: 2.0,
          //                       ),
          //                     ),
          //                   ),
          //                   child: Row(
          //                     children: [
          //                       SvgPicture.asset(
          //                         width: 30,
          //                         color: (index == 2)
          //                             ? Theme.of(context)
          //                                 .colorScheme
          //                                 .primary
          //                             : color2,
          //                         AppIcons.WAVE,
          //                       ),
          //                       Text(
          //                         "ESTATÍSTICAS",
          //                         style: GoogleFonts.rajdhani(
          //                           color: (index == 2)
          //                               ? Theme.of(context)
          //                                   .colorScheme
          //                                   .primary
          //                               : color2,
          //                           fontWeight: FontWeight.bold,
          //                           fontSize: 12,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //         //tabWidget(index, state.atm),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
