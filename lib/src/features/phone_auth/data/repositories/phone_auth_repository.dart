import '../../domain/repositories/i_phone_auth_repository.dart';
import '../phone_auth_datasources/i_phone_auth_datasource.dart';

class PhoneAuthRepository implements IPhoneAuthRepository {
  final IFirebasePhoneAuthDatasource phoneDatasource;

  PhoneAuthRepository({required this.phoneDatasource});

  @override
  Future<bool> verifyPhoneNumber(String phoneNumber,
      Function(String verificationId, int? resendToken) codeSent) {
    return phoneDatasource.verifyPhoneNumber(phoneNumber, codeSent);
  }

  @override
  Future<String?> signInWithCredential(
      String verificationId, String smsCode) async {
    return await phoneDatasource.signInWithCredential(verificationId, smsCode);
  }
}
