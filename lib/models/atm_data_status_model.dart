import 'package:maxalert/models/atm_status_model.dart';
import 'package:maxalert/models/atm_with_status.dart';

import 'atm_model.dart';

class AtmDataModel {
  final List<AtmModel> atms;
  final List<AtmStatusModel> status;

  AtmDataModel({required this.atms, required this.status});

  factory AtmDataModel.fromJson(Map<String, dynamic> json) {
    final atmsData = json['dados']['atms'] as List<dynamic>;
    final statusData = json['dados']['status'] as List<dynamic>;
    final configData = json['dados']['config'] as List<dynamic>;

    final atms = atmsData.map((atm) => AtmModel.fromJson(atm)).toList();
    final status =
        statusData.map((status) => AtmStatusModel.fromJson(status)).toList();

    return AtmDataModel(atms: atms, status: status);
  }

  List<AtmWithStatus> getStatusWithMatchingAtmCodes() {
    List<AtmWithStatus> matchingStatus = [];

    for (var status in status) {
      for (var atm in atms) {
        if (atm.atmSigitCode == status.atm_id) {
          matchingStatus.add(AtmWithStatus(atm: atm, status: status));
          break;
        }
      }
    }

    return matchingStatus;
  }
}
