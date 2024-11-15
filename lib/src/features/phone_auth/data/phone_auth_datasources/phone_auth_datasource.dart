import 'package:firebase_auth/firebase_auth.dart';
import 'package:vivamais/src/core/utils/app_utils.dart';

import 'i_phone_auth_datasource.dart';

class FirebasePhoneAuthDatasource implements IFirebasePhoneAuthDatasource {
  final FirebaseAuth auth;

  FirebasePhoneAuthDatasource({required this.auth});

  @override
  Future<bool> verifyPhoneNumber(String phoneNumber,
      Function(String verificationId, int? resendToken) codeSent) async {
    bool isSendSMS = true;
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (String verificationId, int? resendToken) {
        codeSent(verificationId, resendToken);
      },
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        AppConstants.toast(
            "Ouve um erro no envia do código OTP, tenta mais tarde");
        // throw Exception(e.message);
        isSendSMS = false;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    return isSendSMS;
  }

  @override
  Future<String?> signInWithCredential(
      String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      final user = await auth.signInWithCredential(credential);
      return user.user!.uid;
    } catch (e) {
      AppConstants.toast("Ouve um erro, tente novamente");
      throw e;
    }
  }
}
