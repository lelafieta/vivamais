import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivamais/src/features/auth/domain/usecases/send_otp_number.dart';

import '../../../../../core/error/error_handle.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final SendOtpNumberUseCase sendOtpNumberUseCase;
  OtpCubit({required this.sendOtpNumberUseCase}) : super(OtpInitial());

  Future<void> otp(String code, String verificationId) async {
    emit(OtpLoading());

    try {
      await sendOtpNumberUseCase.call(code, verificationId);
      emit(OtpConfirmed());
    } catch (_) {
      emit(OtpError());
    }
  }
}
