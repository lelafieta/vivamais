import 'dart:async';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_selector/widget/flutter_single_select.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:maxalert/bloc/atm/atm_bloc.dart';
import 'package:maxalert/bloc/atm/atm_state.dart';
import 'package:maxalert/bloc/theme/theme_bloc.dart';
import 'package:maxalert/bloc/theme/theme_state.dart';
import 'package:maxalert/data/repositories/atm_repository.dart';
import 'package:maxalert/models/atm_with_status.dart';
import 'package:maxalert/presentation/screens/atm/atm_details_screen.dart';
import 'package:maxalert/presentation/screens/atm/widget/atm_reload_component.dart';
import 'package:maxalert/presentation/screens/atm/widget/atm_widget.dart';
import 'package:maxalert/presentation/screens/atm/widget/atm_widget_skeleton.dart';
import 'package:maxalert/presentation/screens/login_screen.dart';
import 'package:maxalert/presentation/screens/map/map_screen.dart';
import 'package:maxalert/utils/app_colors.dart';
import 'package:maxalert/utils/app_icons.dart';
import 'package:maxalert/utils/app_images.dart';
import 'package:maxalert/utils/app_utils.dart';

class AtmScreen extends StatefulWidget {
  final int type;
  const AtmScreen({super.key, required this.type});

  @override
  State<AtmScreen> createState() => _AtmScreenState();
}

class _AtmScreenState extends State<AtmScreen> {
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

  late AtmBloc bloc;
  Rx<List<AtmWithStatus>> atms = Rx<List<AtmWithStatus>>([]);
  int _searchIndex = 0;
  bool control = false;
  String query = "";
  bool controleState = false;

  @override
  void initState() {
    super.initState();
    controleState = true;
    getTheme();
    bloc = AtmBloc(atmRepository: _atmRepository);
    bloc.add(AtmLoadingEvent());
  }

  TextEditingController _query = TextEditingController();

  void getTheme() async {
    storageTheme = await storage.read(key: "theme_preference");
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                AppUtils.profile(context);
              },
              child: Container(
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
            ),
            Container(
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: (themeBloc.state is ThemeDarkState)
                      ? AssetImage(
                          AppImages.MAIN_LOGO_WHITE,
                        )
                      : AssetImage(
                          AppImages.MAIN_LOGO,
                        ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // InkWell(
                //   onTap: () {
                //     Get.to(MapScreen());
                //   },
                //   child: SvgPicture.asset(
                //     width: 30,
                //     color: Theme.of(context).colorScheme.primary,
                //     AppIcons.MAP,
                //   ),
                // ),
                // SizedBox(
                //   width: 10,
                // ),
                InkWell(
                  onTap: () {
                    AppUtils.menu(context);
                  },
                  child: SvgPicture.asset(
                    width: 20,
                    color: Theme.of(context).colorScheme.primary,
                    AppIcons.MORE_MENU,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          bloc.add(
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
                padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 8),
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
                                color: Theme.of(context).colorScheme.background,
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
                                  bloc.add(AtmSearchEvent(
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
                                  bloc.add(AtmFilterEvent(
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
                  padding: EdgeInsets.only(left: 5, right: 5, top: 0),
                  child: BlocBuilder<AtmBloc, AtmState>(
                      bloc: bloc,
                      builder: (context, state) {
                        if (state is AtmInitialState) {
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 42,
                                child: ListView(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(5),
                                      height: 50,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      child: ListView.builder(
                                          itemCount: 8,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, intindex) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
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
                                                  Container(
                                                    width: 80,
                                                    child: Text(
                                                      "",
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: GridView.builder(
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10.0,
                                      crossAxisSpacing: 10.0,
                                      childAspectRatio: 1,
                                      mainAxisExtent: 380,
                                    ),
                                    itemCount: 4,
                                    itemBuilder: (context, index) {
                                      return AtmWidgetSkeleton();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        if (state is AtmLoadingState) {
                          return Text("OLAAA");
                        }
                        if (state is AtmFailureState) {
                          if (state.code == 401) {
                            return Center(
                              child: AtmReloadComponent(
                                state: state,
                                actionSumbit: () {
                                  final secureStorage = FlutterSecureStorage();
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
                                bloc.add(
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
                          print("OLA SIIR ${state.atms.length}");
                          //atms.value = state.atms;
                          control = true;
                          if (state.atms.length == 0) {
                            return Container(
                              width: double.infinity,
                              height: 50,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    width: double.infinity,
                                    height: 50,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              contador = atms.value.length;
                                              _searchIndex = 0;
                                            });

                                            bloc.add(
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

                                            bloc.add(
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
                                            bloc.add(
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
                                            bloc.add(
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
                                            bloc.add(
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
                                            bloc.add(
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
                                            bloc.add(
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
                                            bloc.add(
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
                                            bloc.add(
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
                                            bloc.add(
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
                                            bloc.add(
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
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 200),
                                      child: Text(
                                        "SEM ATMs",
                                        style: GoogleFonts.rajdhani(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                                            bloc.add(
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
                                            bloc.add(
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
                                            bloc.add(
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
                                            bloc.add(
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
                                            bloc.add(
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
                                            bloc.add(
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
                                            bloc.add(
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
                                            bloc.add(
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
                                            bloc.add(
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
                                            bloc.add(
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
                                            bloc.add(
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
                                  // Expanded(
                                  //   child: ListView.builder(
                                  //     itemCount: state.atms.length,
                                  //     itemBuilder: (context, int i) {
                                  //       return Text(
                                  //           "${state.atms.elementAt(i).atm.atmSigitCode}");
                                  //     },
                                  //   ),
                                  // ),
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        LoadingMoreList<AtmWithStatus>(
                                          ListConfig<AtmWithStatus>(
                                            physics: ClampingScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                AtmWithStatus atm, int index) {
                                              return InkWell(
                                                onTap: () {
                                                  Get.to(
                                                    () => AtmDetailsScreen(
                                                      atm: atm.atm,
                                                      status: atm.status,
                                                    ),
                                                  ); // Passando o objeto AtmModel para a tela de detalhes
                                                },
                                                child: AtmWidget(
                                                  atm: atm.atm,
                                                  status: atm.status,
                                                ),
                                              );
                                            },
                                            indicatorBuilder:
                                                (context, status) {
                                              if (_showEndOfListMessage) {
                                                return Text("");
                                              }
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: GridView.builder(
                                                  physics:
                                                      ClampingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 5.0,
                                                    crossAxisSpacing: 5.0,
                                                    childAspectRatio: 1,
                                                    mainAxisExtent: 350,
                                                  ),
                                                  itemCount: 4,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return AtmWidgetSkeleton();
                                                  },
                                                ),
                                              );
                                            },
                                            sourceList: MySourceList(
                                              onEndReached: () {
                                                _showEndOfListMessage = true;
                                              },
                                              fullList: state.atms,
                                            ),
                                            controller: _controller,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 5.0,
                                              crossAxisSpacing: 5.0,
                                              childAspectRatio: 1,
                                              mainAxisExtent: 350,
                                            ),
                                          ),
                                        ),

                                        // ListView.builder(
                                        //   itemCount: state.atms.length,
                                        //   itemBuilder: (context, index) {
                                        //     return LazyLoadingList(
                                        //       initialSizeOfItems: 4,
                                        //       index: index,
                                        //       hasMore: true,
                                        //       loadMore: () =>
                                        //           print('Loading More'),
                                        //       child: ListTile(
                                        //         title:
                                        //             Text('${state.atms[index]}'),
                                        //       ),
                                        //     );
                                        //   },
                                        // )
                                      ],
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
      extendBody: true,
    );
  }
}

class MySourceList extends LoadingMoreBase<AtmWithStatus> {
  int _currentPage = 1;
  int _itemsPerPage = 1;
  final List<AtmWithStatus> _fullList;
  final VoidCallback onEndReached;
  //bool _reachedEnd = false; // Variável para controlar se chegou ao final

  ValueNotifier<bool> _reachedEnd = ValueNotifier<bool>(false);

  MySourceList(
      {required this.onEndReached, required List<AtmWithStatus> fullList})
      : _fullList = fullList;

  @override
  bool get hasMore => !_reachedEnd.value; // Verifica se não chegou ao final

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    if (_reachedEnd.value) {
      return false;
    }

    await Future.delayed(Duration(milliseconds: 1));

    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = _currentPage * _itemsPerPage;

    if (endIndex > _fullList.length) {
      endIndex = _fullList.length;
      //print("FIM!!!!!!!!!!!");
      onEndReached();
      _reachedEnd.value = true;
      // Define como verdadeiro quando chega ao final
    }

    if (startIndex < endIndex) {
      List<AtmWithStatus> newItems = _fullList.sublist(startIndex, endIndex);
      addAll(newItems);
      _currentPage++;
    }

    return true;
  }
}

// import 'package:flutter/material.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// class AtmScreen extends StatelessWidget {
//   final int type;

//   const AtmScreen({super.key, required this.type});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final PagingController<int, String> _pagingController =
//       PagingController(firstPageKey: 0);

//   @override
//   void initState() {
//     super.initState();
//     _pagingController.addPageRequestListener((pageKey) {
//       // Aqui você deve carregar os dados da próxima página e adicioná-los ao controller.
//       // Suponha que você tenha uma função fetchData que retorne uma lista de strings.
//       fetchData(pageKey).then((items) {
//         if (items.isEmpty) {
//           // Indique que não há mais páginas a serem carregadas
//           _pagingController.appendLastPage([]);
//         } else {
//           final nextPageKey = pageKey + 1;
//           _pagingController.appendPage(items, nextPageKey);
//         }
//       });
//     });
//   }

//   Future<List<String>> fetchData(int pageKey) async {
//     // Simule uma chamada assíncrona que busca dados da página
//     await Future.delayed(Duration(seconds: 2));
//     return List.generate(10, (index) => 'Item ${pageKey * 20 + index}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Paged Grid Example'),
//       ),
//       body: PagedGridView<int, String>(
//         pagingController: _pagingController,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, // Número de colunas no grid
//           crossAxisSpacing: 16.0, // Espaçamento horizontal entre itens
//           mainAxisSpacing: 16.0, // Espaçamento vertical entre itens
//         ),
//         builderDelegate: PagedChildBuilderDelegate<String>(
//           itemBuilder: (context, item, index) {
//             return Card(
//               child: Center(
//                 child: Text(item),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _pagingController.dispose();
//     super.dispose();
//   }
// }
