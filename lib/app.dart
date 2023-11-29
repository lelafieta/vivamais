import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:freerasp/freerasp.dart';
import 'package:get/get.dart';
import 'package:maxalert/bloc/auth/auth_bloc.dart';
import 'package:maxalert/bloc/biometric/biometric_bloc.dart';
import 'package:maxalert/bloc/biometric/biometric_event.dart';
import 'package:maxalert/bloc/map/map_bloc.dart';
import 'package:maxalert/bloc/theme/theme_bloc.dart';
import 'package:maxalert/bloc/theme/theme_event.dart';
import 'package:maxalert/bloc/theme/theme_state.dart';
import 'package:maxalert/data/repositories/atm_repository.dart';
import 'package:maxalert/data/services/api_service.dart';
import 'package:maxalert/presentation/screens/biometric_screen.dart';
import 'package:maxalert/presentation/screens/dev_screen.dart';
import 'package:maxalert/presentation/screens/root_screen.dart';
import 'package:maxalert/themes/app_theme.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppController extends StatefulWidget {
  const AppController({super.key});

  @override
  State<AppController> createState() => _AppControllerState();
}

class AuthValueNotifier extends ValueNotifier<bool> {
  AuthValueNotifier(bool value) : super(value);
}

class _AppControllerState extends State<AppController>
    with WidgetsBindingObserver {
  final AuthService authService = AuthService();

  final LocalAuthentication _localAuthentication = LocalAuthentication();
  late final AtmRepository atmRepository;

  ValueNotifier<bool> _isAuthenticated = ValueNotifier<bool>(false);
  ValueNotifier<bool> callBiometric = ValueNotifier<bool>(false);
  ValueNotifier<int> segundosRestantes = ValueNotifier<int>(0);

  late ThemeBloc blocTheme;

  bool? _jailbroken;
  bool? _developerMode;

  void initTalsec() async {
    final hash =
        "48:18:FF:D1:23:25:2B:87:D2:3C:99:EE:1D:57:7F:71:4C:64:1F:BA:EC:18:E1:B0:74:C1:36:20:62:73:88:A1";
    final baseHash = hashConverter.fromSha256toBase64(hash);

    final app = TalsecConfig(
      watcherMail: "developer@afrizona.co.ao",
      androidConfig: AndroidConfig(
        packageName: "com.afrizona.maxalerts_app",
        signingCertHashes: [baseHash],
        supportedStores: ['abd'],
      ),
    );

    final callback = ThreatCallback(
      onAppIntegrity: () => print("App integrity"),
      onObfuscationIssues: () => print("Obfuscation issues"),
      onDebug: () => print(0),
      onDeviceBinding: () => print("Device binding"),
      onDeviceID: () => print("Device ID"),
      onHooks: () => print("Hooks"),
      onPasscode: () => print("Passcode not set"),
      onPrivilegedAccess: () => print("Privileged access"),
      onSecureHardwareNotAvailable: () =>
          print("Secure hardware not available"),
      onSimulator: () => print("Simulator"),
      onUnofficialStore: () => print("Unofficial store"),
    );

    // Attaching listener
    Talsec.instance.attachListener(callback);
    await Talsec.instance.start(app);
  }

  @override
  void initState() {
    super.initState();
    blocTheme = ThemeBloc();

    //initTalsec();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool jailbroken;
    bool developerMode;

    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      developerMode = await FlutterJailbreakDetection.developerMode;
    } on PlatformException {
      jailbroken = true;
      developerMode = true;
    }

    if (!mounted) return;

    setState(() {
      _jailbroken = jailbroken;
      _developerMode = developerMode;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      segundosRestantes.value = 0;
      //segundosRestantes = 180;
      callBiometric.value = true;
      _isAuthenticated.value = false;
      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (segundosRestantes.value > 0) {
            segundosRestantes.value--;
          } else {
            timer.cancel();
          }
        });
      });
    } else if (state == AppLifecycleState.resumed) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _isAuthenticated.value = false;
    callBiometric.value == false;
    super.dispose();
  }

  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    EasyLoading.init();

    // if (_jailbroken == true){
    //   return MaterialApp(
    //       home: Scaffold(
    //         body: RootScreen(),
    //     ),
    //   );
    // }

    // else if (_developerMode == true){
    //   return MaterialApp(
    //       home: Scaffold(
    //         body: DevScreen(),
    //     ),
    //   );
    // }

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc()..add(ToggleThemeEvent()),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authService: authService),
        ),
        BlocProvider<BiometricBloc>(
          create: (context) => BiometricBloc()..add(BiometricStartingEvent()),
        ),
        BlocProvider<MapBloc>(
          create: (context) => MapBloc()..add(MapLoadingEvent(atms: [])),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          ThemeMode themeMode;

          if (state is ThemeLightState) {
            themeMode = ThemeMode.light;
          } else if (state is ThemeDarkState) {
            themeMode = ThemeMode.dark;
          } else {
            themeMode = ThemeMode.system;
          }

          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MAXALERTS',
            theme: ligthTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            home: BiometricScreen(),
            builder: EasyLoading.init(),
          );
        },
      ),
    );
  }
}
