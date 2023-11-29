import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:maxalert/bloc/mda/mda_bloc.dart';
import 'package:maxalert/bloc/mda/mda_state.dart';
import 'package:maxalert/bloc/theme/theme_bloc.dart';
import 'package:maxalert/bloc/theme/theme_state.dart';
import 'package:maxalert/data/repositories/mda_repository.dart';
import 'package:maxalert/models/mda_model.dart';
import 'package:maxalert/presentation/screens/login_screen.dart';
import 'package:maxalert/presentation/screens/mda/mda_details_screen.dart';
import 'package:maxalert/presentation/screens/mda/widget/mda_reload_component.dart';
import 'package:maxalert/presentation/screens/mda/widget/mda_widget.dart';
import 'package:maxalert/presentation/screens/mda/widget/mda_widget_skeleton.dart';
import 'package:maxalert/utils/app_colors.dart';
import 'package:maxalert/utils/app_icons.dart';
import 'package:maxalert/utils/app_images.dart';
import 'package:maxalert/utils/app_utils.dart';

class MdaScreen extends StatefulWidget {
  const MdaScreen({super.key});

  @override
  State<MdaScreen> createState() => _MdaScreenState();
}

class _MdaScreenState extends State<MdaScreen> {
  final ScrollController _controller = ScrollController();
  bool _showEndOfListMessage = true;

  final MdaRepository _mdaRepository = MdaRepository();
  List<MdaModel> mdas = [];

  late MdaBloc bloc;
  int _searchIndex = 0;

  bool control = false;
  bool press = false;
  String query = "";

  ValueNotifier<int> count = ValueNotifier<int>(0);

  @override
  void initState() {
    control = true;
    super.initState();
    bloc = MdaBloc(mdaRepository: _mdaRepository);
    bloc.add(MdaLoadingEvent());
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  String? storageTheme;
  FlutterSecureStorage storage = FlutterSecureStorage();

  TextEditingController _query = TextEditingController();

  void getTheme() async {
    storageTheme = await storage.read(key: "theme_preference");
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
                // SizedBox(
                //   width: 5,
                // ),
                // SvgPicture.asset(
                //   width: 20,
                //   color: Theme.of(context).colorScheme.primary,
                //   AppIcons.SETTINGS,
                // ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
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
                              bloc.add(MdaSearchEvent(
                                  mdas: mdas,
                                  query: value,
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
                    width: 70,
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.MAIN_BACKGROUND,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          "TODOS",
                          style: GoogleFonts.racingSansOne(
                            fontSize: 16,
                            color: AppColors.SECOND_COLOR,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5, right: 5, top: 5),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: BlocBuilder<MdaBloc, MdaState>(
                  bloc: bloc,
                  builder: (context, state) {
                    if (state is MdaInitialState) {
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
                                  return MdaWidgetSkeleton();
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    if (state is MdaFailureState) {
                      if (state.code == 401) {
                        return Center(
                          child: MdaReloadComponent(
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
                      if (state.code == 467) {
                        return Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Icon(
                                FontAwesomeIcons.warning,
                                size: 40,
                                color: Colors.orange,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Sem MDAs",
                                style: GoogleFonts.rajdhani(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Center(
                        child: MdaReloadComponent(
                          state: state,
                          actionSumbit: () {
                            bloc.add(MdaReloadEvent(mdas: mdas));
                          },
                          text: "CARREGAR",
                        ),
                      );
                    }

                    if (state is MdaSuccessState) {
                      if (control == true) {
                        mdas = state.mdas;
                        control = false;
                      }

                      count.value = state.mdas.length;
                      if (state.mdas.length == 0) {
                        return Container(
                          width: double.infinity,
                          height: 50,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(5),
                                height: 50,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _searchIndex = 0;
                                        });
                                        bloc.add(
                                          MdaReloadEvent(
                                            mdas: mdas,
                                            query: query,
                                            indexSearch: _searchIndex,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
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
                                          ],
                                        ),
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
                                              "TODOS MDAS",
                                              style: GoogleFonts.rajdhani(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: (_searchIndex == 0)
                                                    ? Colors.white
                                                    : AppColors.MAIN_COLOR,
                                              ),
                                            ),
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
                                          _searchIndex = 1;
                                        });
                                        bloc.add(MdaOnlineEvent(mdas: mdas));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
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
                                              Icons.wifi,
                                              color: (_searchIndex == 1)
                                                  ? AppColors.WHITE_COLOR
                                                  : AppColors.GREEN_COLOR,
                                            ),
                                            Text(
                                              "ONLINE",
                                              style: GoogleFonts.rajdhani(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: (_searchIndex == 1)
                                                    ? AppColors.WHITE_COLOR
                                                    : AppColors.GREEN_COLOR,
                                              ),
                                            ),
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
                                          _searchIndex = 2;
                                        });
                                        bloc.add(MdaOfflineEvent(mdas: mdas));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                          color: (_searchIndex == 2)
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
                                              Icons.error,
                                              color: (_searchIndex == 2)
                                                  ? AppColors.WHITE_COLOR
                                                  : AppColors.ORANGE_COLOR,
                                            ),
                                            Text(
                                              "ANOMALIA",
                                              style: GoogleFonts.rajdhani(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: (_searchIndex == 2)
                                                    ? AppColors.WHITE_COLOR
                                                    : AppColors.ORANGE_COLOR,
                                              ),
                                            ),
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
                                        bloc.add(MdaAnomaliaEvent(mdas: mdas));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                          color: (_searchIndex == 3)
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
                                              color: (_searchIndex == 3)
                                                  ? AppColors.WHITE_COLOR
                                                  : Colors.red,
                                            ),
                                            Text(
                                              "OFFILNE",
                                              style: GoogleFonts.rajdhani(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: (_searchIndex == 3)
                                                    ? AppColors.WHITE_COLOR
                                                    : Colors.red,
                                              ),
                                            ),
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
                                        bloc.add(MdaComPapelEvent(mdas: mdas));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                          color: (_searchIndex == 4)
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
                                              Icons.check_box,
                                              color: (_searchIndex == 4)
                                                  ? AppColors.WHITE_COLOR
                                                  : AppColors.GREEN_COLOR,
                                            ),
                                            Text(
                                              "COM PAPEL",
                                              style: GoogleFonts.rajdhani(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: (_searchIndex == 4)
                                                    ? AppColors.WHITE_COLOR
                                                    : AppColors.GREEN_COLOR,
                                              ),
                                            ),
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
                                            MdaPoucoPapelEvent(mdas: mdas));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                          color: (_searchIndex == 5)
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
                                              Icons.rectangle,
                                              color: (_searchIndex == 5)
                                                  ? AppColors.WHITE_COLOR
                                                  : AppColors.ORANGE_COLOR,
                                            ),
                                            Text(
                                              "POUCO PAPEL",
                                              style: GoogleFonts.rajdhani(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: (_searchIndex == 5)
                                                    ? AppColors.WHITE_COLOR
                                                    : AppColors.ORANGE_COLOR,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    // Container(
                                    //   padding: EdgeInsets.symmetric(horizontal: 10),
                                    //   decoration: BoxDecoration(
                                    //     border: Border.all(
                                    //       width: 1,
                                    //       color: AppColors.RED_COLOR,
                                    //     ),
                                    //     borderRadius: BorderRadius.circular(10),
                                    //   ),
                                    //   child: Row(
                                    //     crossAxisAlignment: CrossAxisAlignment.center,
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     children: [
                                    //       Icon(
                                    //         Icons.monitor_heart,
                                    //         color: AppColors.RED_COLOR,
                                    //       ),
                                    //       Text(
                                    //         "ANOMALIA TÉCNICA",
                                    //         style: GoogleFonts.rajdhani(
                                    //           fontWeight: FontWeight.bold,
                                    //           fontSize: 12,
                                    //           color: AppColors.RED_COLOR,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   width: 10,
                                    // ),

                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _searchIndex = 6;
                                        });
                                        bloc.add(MdaSemPapelEvent(mdas: mdas));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                          color: (_searchIndex == 6)
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
                                                  .cancel_presentation_outlined,
                                              color: (_searchIndex == 6)
                                                  ? AppColors.WHITE_COLOR
                                                  : AppColors.RED_COLOR,
                                            ),
                                            Text(
                                              "SEM PAPEL",
                                              style: GoogleFonts.rajdhani(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: (_searchIndex == 6)
                                                    ? AppColors.WHITE_COLOR
                                                    : AppColors.RED_COLOR,
                                              ),
                                            ),
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
                                            MdaAcima3MilhoesEvent(mdas: mdas));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                          color: (_searchIndex == 7)
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
                                              Icons.trending_up_rounded,
                                              color: (_searchIndex == 7)
                                                  ? AppColors.WHITE_COLOR
                                                  : AppColors.GREEN_COLOR,
                                            ),
                                            Text(
                                              "FAZER RECOLHA",
                                              style: GoogleFonts.rajdhani(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: (_searchIndex == 7)
                                                    ? AppColors.WHITE_COLOR
                                                    : AppColors.GREEN_COLOR,
                                              ),
                                            ),
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
                                            MdaAbaixo3MilhoesEvent(mdas: mdas));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                          color: (_searchIndex == 8)
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
                                              color: (_searchIndex == 8)
                                                  ? AppColors.WHITE_COLOR
                                                  : AppColors.ORANGE_COLOR,
                                            ),
                                            Text(
                                              "ABAIXO DE 20 MILÕES",
                                              style: GoogleFonts.rajdhani(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: (_searchIndex == 8)
                                                    ? AppColors.WHITE_COLOR
                                                    : AppColors.ORANGE_COLOR,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 200),
                                  child: Text(
                                    "SEM MDAs",
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
                      return RefreshIndicator(
                        onRefresh: () async {
                          bloc.add(
                            MdaReloadEvent(
                              mdas: mdas,
                              query: query,
                              indexSearch: _searchIndex,
                            ),
                          );
                        },
                        child: FloatingDraggableWidget(
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
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _searchIndex = 0;
                                          });
                                          bloc.add(
                                            MdaReloadEvent(
                                              mdas: mdas,
                                              query: query,
                                              indexSearch: _searchIndex,
                                              type: _searchIndex,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
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
                                            ],
                                          ),
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
                                                "TODOS MDAS",
                                                style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: (_searchIndex == 0)
                                                      ? Colors.white
                                                      : AppColors.MAIN_COLOR,
                                                ),
                                              ),
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
                                            _searchIndex = 1;
                                          });
                                          bloc.add(MdaOnlineEvent(mdas: mdas));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
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
                                                Icons.wifi,
                                                color: (_searchIndex == 1)
                                                    ? AppColors.WHITE_COLOR
                                                    : AppColors.GREEN_COLOR,
                                              ),
                                              Text(
                                                "ONLINE",
                                                style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: (_searchIndex == 1)
                                                      ? AppColors.WHITE_COLOR
                                                      : AppColors.GREEN_COLOR,
                                                ),
                                              ),
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
                                            _searchIndex = 2;
                                          });
                                          bloc.add(MdaOfflineEvent(mdas: mdas));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                            color: (_searchIndex == 2)
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
                                                Icons.error,
                                                color: (_searchIndex == 2)
                                                    ? AppColors.WHITE_COLOR
                                                    : AppColors.ORANGE_COLOR,
                                              ),
                                              Text(
                                                "ANOMALÍA",
                                                style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: (_searchIndex == 2)
                                                      ? AppColors.WHITE_COLOR
                                                      : AppColors.ORANGE_COLOR,
                                                ),
                                              ),
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
                                              MdaAnomaliaEvent(mdas: mdas));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                            color: (_searchIndex == 3)
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
                                                color: (_searchIndex == 3)
                                                    ? AppColors.WHITE_COLOR
                                                    : Colors.red,
                                              ),
                                              Text(
                                                "OFFILNE",
                                                style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: (_searchIndex == 3)
                                                      ? AppColors.WHITE_COLOR
                                                      : Colors.red,
                                                ),
                                              ),
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
                                              MdaComPapelEvent(mdas: mdas));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                            color: (_searchIndex == 4)
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
                                                Icons.check_box,
                                                color: (_searchIndex == 4)
                                                    ? AppColors.WHITE_COLOR
                                                    : AppColors.GREEN_COLOR,
                                              ),
                                              Text(
                                                "COM PAPEL",
                                                style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: (_searchIndex == 4)
                                                      ? AppColors.WHITE_COLOR
                                                      : AppColors.GREEN_COLOR,
                                                ),
                                              ),
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
                                              MdaPoucoPapelEvent(mdas: mdas));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                            color: (_searchIndex == 5)
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
                                                Icons.rectangle,
                                                color: (_searchIndex == 5)
                                                    ? AppColors.WHITE_COLOR
                                                    : AppColors.ORANGE_COLOR,
                                              ),
                                              Text(
                                                "POUCO PAPEL",
                                                style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: (_searchIndex == 5)
                                                      ? AppColors.WHITE_COLOR
                                                      : AppColors.ORANGE_COLOR,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      // Container(
                                      //   padding: EdgeInsets.symmetric(horizontal: 10),
                                      //   decoration: BoxDecoration(
                                      //     border: Border.all(
                                      //       width: 1,
                                      //       color: AppColors.RED_COLOR,
                                      //     ),
                                      //     borderRadius: BorderRadius.circular(10),
                                      //   ),
                                      //   child: Row(
                                      //     crossAxisAlignment: CrossAxisAlignment.center,
                                      //     mainAxisAlignment: MainAxisAlignment.center,
                                      //     children: [
                                      //       Icon(
                                      //         Icons.monitor_heart,
                                      //         color: AppColors.RED_COLOR,
                                      //       ),
                                      //       Text(
                                      //         "ANOMALIA TÉCNICA",
                                      //         style: GoogleFonts.rajdhani(
                                      //           fontWeight: FontWeight.bold,
                                      //           fontSize: 12,
                                      //           color: AppColors.RED_COLOR,
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   width: 10,
                                      // ),

                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _searchIndex = 6;
                                          });
                                          bloc.add(
                                              MdaSemPapelEvent(mdas: mdas));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                            color: (_searchIndex == 6)
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
                                                    .cancel_presentation_outlined,
                                                color: (_searchIndex == 6)
                                                    ? AppColors.WHITE_COLOR
                                                    : AppColors.RED_COLOR,
                                              ),
                                              Text(
                                                "SEM PAPEL",
                                                style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: (_searchIndex == 6)
                                                      ? AppColors.WHITE_COLOR
                                                      : AppColors.RED_COLOR,
                                                ),
                                              ),
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
                                          bloc.add(MdaAcima3MilhoesEvent(
                                              mdas: mdas));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                            color: (_searchIndex == 7)
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
                                                Icons.trending_up_rounded,
                                                color: (_searchIndex == 7)
                                                    ? AppColors.WHITE_COLOR
                                                    : AppColors.GREEN_COLOR,
                                              ),
                                              Text(
                                                "FAZER RECOLHA",
                                                style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: (_searchIndex == 7)
                                                      ? AppColors.WHITE_COLOR
                                                      : AppColors.GREEN_COLOR,
                                                ),
                                              ),
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
                                          bloc.add(MdaAbaixo3MilhoesEvent(
                                              mdas: mdas));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                            color: (_searchIndex == 8)
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
                                                color: (_searchIndex == 8)
                                                    ? AppColors.WHITE_COLOR
                                                    : AppColors.ORANGE_COLOR,
                                              ),
                                              Text(
                                                "ABAIXO DE 20 MILÕES",
                                                style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: (_searchIndex == 8)
                                                      ? AppColors.WHITE_COLOR
                                                      : AppColors.ORANGE_COLOR,
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
                                  child: LoadingMoreList<MdaModel>(
                                    ListConfig<MdaModel>(
                                      itemBuilder: (BuildContext context,
                                          MdaModel mda, int index) {
                                        return InkWell(
                                          onTap: () {
                                            Get.to(
                                              () => MdaDetailsScreen(
                                                mda: mda,
                                              ),
                                            ); // Passando o objeto AtmModel para a tela de detalhes
                                          },
                                          child: MdaWidget(mda: mda),
                                        );
                                      },
                                      indicatorBuilder: (context, status) {
                                        if (_showEndOfListMessage) {
                                          return Text("");
                                        }
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: GridView.builder(
                                            physics: ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 5.0,
                                              crossAxisSpacing: 5.0,
                                              childAspectRatio: 1,
                                              mainAxisExtent: 350,
                                            ),
                                            itemCount: 18,
                                            itemBuilder: (context, index) {
                                              return MdaWidgetSkeleton();
                                            },
                                          ),
                                        );
                                      },
                                      sourceList: MySourceList(
                                        onEndReached: () {
                                          _showEndOfListMessage = true;
                                        },
                                        fullList: state.mdas,
                                      ),
                                      controller: _controller,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 5.0,
                                        crossAxisSpacing: 5.0,
                                        childAspectRatio: 1,
                                        mainAxisExtent: 380,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
      extendBody: true,
    );
  }
}

class MySourceList extends LoadingMoreBase<MdaModel> {
  int _currentPage = 1;
  int _itemsPerPage = 1;
  final List<MdaModel> _fullList;
  final VoidCallback onEndReached;

  MySourceList({required this.onEndReached, required List<MdaModel> fullList})
      : _fullList = fullList;

  @override
  bool get hasMore => (_currentPage * _itemsPerPage) <= _fullList.length;

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    await Future.delayed(Duration(milliseconds: 1));

    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = _currentPage * _itemsPerPage;

    if (endIndex > _fullList.length) {
      endIndex = _fullList.length;
      onEndReached();
    }

    if (startIndex < endIndex) {
      List<MdaModel> newItems = _fullList.sublist(startIndex, endIndex);
      addAll(newItems);
      _currentPage++;
    }

    return true;
  }
}
