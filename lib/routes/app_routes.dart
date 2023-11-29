import 'package:get/get.dart';
import 'package:maxalert/presentation/screens/atm/atm_screen.dart';
import 'package:maxalert/presentation/screens/login_screen.dart';

class AppRoutes {
  static final List<GetPage> routes = [
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(
        name: '/atm',
        page: () => AtmScreen(
              type: 1,
            )),
  ];
}
