import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maxalert/bloc/atm/atm_state.dart';

class AtmReloadComponent extends StatelessWidget {
  final AtmFailureState state;
  final VoidCallback actionSumbit;
  final String text;
  const AtmReloadComponent({
    super.key,
    required this.state,
    required this.actionSumbit,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    Color color = Colors.red;
    Icon icon = Icon(
      Icons.error,
      color: color,
      size: 50,
    );

    String buttonText = text;

    if (state.code == null) {
      state.error = "Verifique a conexão de internet";
    }

    if (state.code == 401) {
      buttonText = "AUTENTICAR";
      color = Colors.orange;
      icon = Icon(
        Icons.warning_rounded,
        color: color,
        size: 50,
      );
    }
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        icon,
        Text(
          "${state.error}",
          style: GoogleFonts.rajdhani(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          onPressed: actionSumbit,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(color),
            textStyle: MaterialStateProperty.all<TextStyle>(
              TextStyle(color: Colors.white),
            ),
          ),
          child: Text(
            "$buttonText",
            style: GoogleFonts.rajdhani(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
