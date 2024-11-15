abstract class IFirebasePhoneAuthDatasource {
  Future<bool> verifyPhoneNumber(
    String phoneNumber,
    Function(String verificationId, int? resendToken) codeSent,
  );
  Future<String?> signInWithCredential(String verificationId, String smsCode);
}
