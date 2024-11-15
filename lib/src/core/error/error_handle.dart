import 'package:vivamais/src/core/error/failure.dart';

class ErrorHandle {
  static String handle(Failure failure) {
    switch (failure.runtimeType) {
      case DuplicateUserFailure:
        return "E-mail já existente";
      case DuplicatePhoneFailure:
        return "Telefone já existente";
      default:
        print(failure);
        return "Ouve um erro no Servidor.";
    }
  }
}
