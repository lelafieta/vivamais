import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/blood_entity.dart';

class BloodModel extends BloodEntity {
  BloodModel(
      {required super.type,
      required super.qtdUsers,
      required super.percentage});

  factory BloodModel.fromJson(Map<String, dynamic> json) => BloodModel(
        type: json["type"],
        qtdUsers: json["qtd_users"],
        percentage: json["percentage"],
      );
}
