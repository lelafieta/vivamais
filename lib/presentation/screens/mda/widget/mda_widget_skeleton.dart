import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maxalert/utils/app_icons.dart';
import 'package:maxalert/utils/app_images.dart';

class MdaWidgetSkeleton extends StatelessWidget {
  const MdaWidgetSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceTint,
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      width: 12,
                      color: Theme.of(context).colorScheme.primary,
                      AppIcons.MAPA_LOCAL,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 10,
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(.5),
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
                      width: 12,
                      color: Theme.of(context).colorScheme.primary,
                      AppIcons.BANK,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 50,
                        height: 10,
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(.5),
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
                      Icons.monetization_on,
                      size: 12,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 10,
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.key,
                                  size: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    height: 10,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withOpacity(.5),
                                  ),
                                ),
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
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 60,
                  left: 10,
                  right: 10,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: AssetImage(
                          AppImages.LOADING,
                        ),
                        fit: BoxFit.scaleDown,
                        opacity: .3,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 110,
                  right: 10,
                  top: 162,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 33,
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 100,
                  top: 160,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 12,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1.0,
                    ),
                  ),
                  width: double.infinity,
                  margin:
                      EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      AppImages.MDA,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.values.first,
                    ),
                  ),
                ),
                Positioned(
                  left: 50,
                  right: 50,
                  top: 10,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
