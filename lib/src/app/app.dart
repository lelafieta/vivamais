import 'package:vivamais/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:vivamais/src/features/phone_auth/presentation/cubit/phone_auth_cubit.dart';
import 'package:vivamais/src/features/user/presentation/cubit/user_cubit.dart';
import 'package:vivamais/src/features/vivaMais/presentation/cubit/viva_mais_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../config/routes/app_pages.dart';
import '../config/theme/themes.dart';
import '../features/auth/presentation/cubit/otp_cubit/otp_cubit.dart';
import '../features/blood/presentation/cubit/blood_cubit.dart';
import '../features/user/presentation/cubit/register_cubit/register_cubit.dart';
import 'di.dart' as di;

class BloodApp extends StatelessWidget {
  const BloodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.instance<AuthCubit>(),
        ),
        BlocProvider(
          create: (_) => di.instance<VivaMaisCubit>(),
        ),
        BlocProvider(
          create: (_) => di.instance<OtpCubit>(),
        ),
        BlocProvider(
          create: (_) => di.instance<PhoneAuthCubit>(),
        ),
        BlocProvider(
          create: (_) => di.instance<UserCubit>(),
        ),
        BlocProvider(
          create: (_) => di.instance<RegisterCubit>(),
        ),
        BlocProvider(
          create: (_) => di.instance<BloodCubit>()..fetchBloods(),
        )
      ],
      child: GetMaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
