import 'package:maxalert/models/atm_model.dart';
import 'package:maxalert/models/atm_status_model.dart';

class AtmWithStatus {
  final AtmModel atm;
  final AtmStatusModel status;

  AtmWithStatus({required this.atm, required this.status});

  factory AtmWithStatus.fromJson(AtmModel atm, AtmStatusModel status) {
    return AtmWithStatus(
      atm: atm,
      status: status,
    );
  }
}
