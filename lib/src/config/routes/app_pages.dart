import 'package:animations/animations.dart';
import 'package:awesome_place_search/awesome_place_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_form_field/phone_form_field.dart';

import 'package:vivamais/src/features/bankBlood/presentation/views/bank_blood_view.dart';
import 'package:vivamais/src/features/donation/presentation/views/create_request_view.dart';
import 'package:vivamais/src/features/donation/presentation/views/donate_accept_view.dart';
import 'package:vivamais/src/features/donation/presentation/views/search_result_view.dart';
import 'package:vivamais/src/features/donation/presentation/views/send_request_view.dart';
import 'package:vivamais/src/features/donor/presentation/views/donor_view.dart';
import 'package:vivamais/src/features/feed/presentation/views/feed_view.dart';
import 'package:vivamais/src/features/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';

import '../../features/account/presentation/views/account_view.dart';

import '../../features/blood/presentation/cubit/blood_cubit.dart';
import '../../features/phone_auth/presentation/views/auth_view.dart';
import '../../features/phone_auth/presentation/views/login_view.dart';
import '../../features/phone_auth/presentation/views/otp_view.dart';
import '../../features/phone_auth/presentation/views/register_view.dart';
import '../../features/vivaMais/presentation/views/viva_mais_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/messages/presentation/views/chat_view .dart';
import '../../features/messages/presentation/views/message_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/post/presentation/views/post_view.dart';
import '../../features/reward/presentation/views/reward_view.dart';
import '../../features/tickets/presentation/views/ticket_view.dart';
import 'routes.dart';
import '../../app/di.dart' as di;

class AppRoutes {
  static Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.initialRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SplashPage();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.onBoardingRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return OnBoargingView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );

      case Routes.authRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return AuthView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.loginRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return LoginView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );

      case Routes.registerRoute:
        final phoneNumber = routeSettings.arguments as PhoneController;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return RegisterView(phoneNumber: phoneNumber);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.otpRoute:
        final param = routeSettings.arguments as Map<String, dynamic>;

        final verificationId = param["verificationId"];
        final phoneNumber = param["phoneNumber"] as PhoneController;

        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return OtpView(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );

      case Routes.vivaMaisRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return VivaMaisView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.homeRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return HomeView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.rewardRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return RewardView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.messageRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return MessageView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.ticketRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return TicketView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.accountRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return AccountView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.chatRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return ChatView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.postRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return PostView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.feedRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FeedView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.bankBloodRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return BankBloodView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.donorRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return DonorView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.createRequestRoute:
        final param = routeSettings.arguments as Map<String, dynamic>;

        final blood = param["blood"] as String;
        final prediction = param["prediction"] as PredictionModel;

        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return CreateRequestView(
              blood: blood,
              prediction: prediction,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.searchResultRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SearchResultView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.sendRequestRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SendRequestView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.donateAcceptRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return DonateAcceptView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      case Routes.bloodRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return VivaMaisView();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      default:
        return MaterialPageRoute(builder: (_) => Center(child: Text("Erro!!")));
    }
  }
}
