import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maxalert/bloc/auth/auth_bloc.dart';
import 'package:maxalert/bloc/auth/auth_state.dart';
import 'package:maxalert/presentation/main_screen.dart';

import 'package:maxalert/presentation/screens/login_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return MainScreen();
        } else if (state is AuthFailure) {
          return LoginScreen();
        } else {
          return LoginScreen(); // Estado inicial ou carregamento
        }
      },
    );
  }
}
