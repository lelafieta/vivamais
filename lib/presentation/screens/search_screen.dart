import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maxalert/utils/app_icons.dart';
import 'package:maxalert/utils/app_images.dart';

class SearchScreen extends StatefulWidget {
  final int type;
  const SearchScreen({super.key, required this.type});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.black12,
                image: DecorationImage(
                  image: AssetImage(AppImages.USER_AVATAR),
                ),
              ),
            ),
            Container(
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    AppImages.MAIN_LOGO,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  width: 20,
                  color: Theme.of(context).colorScheme.background,
                  AppIcons.MORE_MENU,
                ),
                SizedBox(
                  width: 5,
                ),
                SvgPicture.asset(
                  width: 20,
                  color: Theme.of(context).colorScheme.background,
                  AppIcons.SETTINGS,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppImages.PARTICULAR_BACKGROUND,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.all(15),
            //   color: Theme.of(context).colorScheme.secondary,
            //   child: Column(
            //     children: [
            // Container(
            //   color: Theme.of(context).colorScheme.background,
            //   padding: EdgeInsets.only(left: 10),
            //   child: TextField(
            //     style: GoogleFonts.rajdhani(
            //       fontWeight: FontWeight.w900,
            //     ),
            //     decoration: InputDecoration(
            //       hintText: "ID, NOME, SITE",
            //       border: InputBorder.none,
            //     ),
            //   ),
            // ),
            // Text("data"),
            //     ],
            //   ),
            // ),
            Container(
              color: Theme.of(context).colorScheme.secondary,
              padding: EdgeInsets.all(10),
              child: Stack(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 120),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              style: GoogleFonts.rajdhani(
                                fontWeight: FontWeight.w900,
                              ),
                              decoration: InputDecoration(
                                hintText: "ID, NOME, SITE",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 1,
                    child: Container(
                      height: 45,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context)
                              .colorScheme
                              .primary, // Cor de fundo do botão
                          onPrimary: Colors.white, // Cor do texto do botão
                          elevation: 8, // Efeito de elevação
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              5,
                            ), // BorderRadius do botão
                          ),
                        ),
                        child: Text(
                          "ATM",
                          style: GoogleFonts.racingSansOne(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                child: Text("s"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container tabWidget(int index) {
    if (index == 1) {
      return Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: 8,
            itemBuilder: (context, int index) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onError,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  "2023-12-12",
                                  style: GoogleFonts.rajdhani(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  "20:12:00",
                                  style: GoogleFonts.rajdhani(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.key,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.rajdhani(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  fontSize: 10,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'ID: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )),
                                  TextSpan(
                                    text: '2029',
                                    style: GoogleFonts.rajdhani(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Text(
                      "Erro na entrega de cartão. O cartão é capturado",
                      style: GoogleFonts.rajdhani(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(.8),
                      ),
                    ),
                  ],
                ),
              );
            }),
      );
    }
    if (index == 2) {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "INFORMAÇÕES DO ÚLTIMO CARREGAMENTO",
                        style: GoogleFonts.rajdhani(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "2023-12-12",
                      style: GoogleFonts.rajdhani(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: Theme.of(context).colorScheme.secondary.withOpacity(.2),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 35,
                            child: Text(
                              "16",
                              style: GoogleFonts.rajdhani(
                                fontSize: 45,
                                height: 1,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                          Text(
                            "AGOSTO",
                            style: GoogleFonts.rajdhani(
                              fontSize: 12,
                              height: 0,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                          Text(
                            "20:20:20",
                            style: GoogleFonts.rajdhani(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "VALOR CARREGADO",
                            style: GoogleFonts.rajdhani(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.monetization_on,
                                color: Theme.of(context).colorScheme.primary,
                                size: 18,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "15,416,000 AOA",
                                style: GoogleFonts.racingSansOne(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Container(
                      width: 60,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 35,
                            child: Text(
                              "20",
                              style: GoogleFonts.rajdhani(
                                fontSize: 45,
                                height: 1,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                          Text(
                            "AGOSTO",
                            style: GoogleFonts.rajdhani(
                              fontSize: 12,
                              height: 0,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                          Text(
                            "20:20:20",
                            style: GoogleFonts.rajdhani(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "VALOR CARREGADO",
                            style: GoogleFonts.rajdhani(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.monetization_on,
                                color: Theme.of(context).colorScheme.primary,
                                size: 18,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "15,416,000 AOA",
                                style: GoogleFonts.racingSansOne(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Container(
                      width: 60,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 35,
                            child: Text(
                              "16",
                              style: GoogleFonts.rajdhani(
                                fontSize: 45,
                                height: 1,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                          Text(
                            "AGOSTO",
                            style: GoogleFonts.rajdhani(
                              fontSize: 12,
                              height: 0,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                          Text(
                            "20:20:20",
                            style: GoogleFonts.rajdhani(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "VALOR CARREGADO",
                            style: GoogleFonts.rajdhani(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.monetization_on,
                                color: Theme.of(context).colorScheme.primary,
                                size: 18,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "15,416,000 AOA",
                                style: GoogleFonts.racingSansOne(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: 8,
        itemBuilder: (context, int index) {
          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          "2023-12-12",
                          style: GoogleFonts.rajdhani(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          "20:12:00",
                          style: GoogleFonts.rajdhani(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.credit_card_outlined,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "10,1012",
                      style: GoogleFonts.rajdhani(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
