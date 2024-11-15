// data/models/post_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/request_entity.dart';

class RequestModel extends RequestEntity {
  RequestModel({
    super.id,
    super.latitude,
    super.longitude,
    super.address,
    super.date,
    super.createdAt,
    super.updatedAt,
    super.status,
    super.description,
    super.blood,
    super.userId,
    super.file,
    super.donorId,
  });

  // Converting RequestModel to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'date': date?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'status': status,
      'description': description,
      'blood': blood,
      'user_id': userId,
      'file': file,
      'donor_id': donorId,
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
      date: DateTime.parse(map['date']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      status: map['status'],
      description: map['description'],
      blood: map['blood'],
      userId: map['user_id'],
      file: map['file'],
      donorId: map['donor_id'],
    );
  }

  factory RequestModel.fromSnapshot(DocumentSnapshot snapshot) {
    return RequestModel.fromMap(snapshot.data() as Map<String, dynamic>);
  }
}
