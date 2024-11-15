import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    super.uid,
    super.firstName,
    super.lastName,
    super.phone,
    super.email,
    super.password,
    super.avatar_url,
    super.gender,
    super.address,
    super.latitude,
    super.longitude,
    super.blood,
    super.is_donor,
    super.isValiable,
    super.birth,
    super.updated_at,
    super.created_at,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      uid: snapshot.get("uid"),
      firstName: snapshot.get("first_name"),
      lastName: snapshot.get("first_name"),
      phone: snapshot.get("phome"),
      email: snapshot.get("email"),
      password: snapshot.get("password"),
      avatar_url: snapshot.get("avatar_url"),
      gender: snapshot.get("gender"),
      address: snapshot.get("address"),
      latitude: snapshot.get("latitude"),
      longitude: snapshot.get("longitude"),
      blood: snapshot.get("blood"),
      isValiable: snapshot.get("is_valiable"),
      is_donor: snapshot.get("is_donor"),
      birth: DateTime.parse(snapshot.get("birth")),
      updated_at: DateTime.parse(snapshot.get("updated_at")),
      created_at: DateTime.parse(snapshot.get("created_at")),
    );
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'uid': uid,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'avatar_url': avatar_url,
      'gender': gender,
      'blood': blood,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'is_valiable': isValiable,
      'is_donor': is_donor,
      'birth': birth != null ? birth!.toIso8601String() : null,
      'updated_at': updated_at != null ? updated_at!.toIso8601String() : null,
      'created_at': created_at != null ? created_at!.toIso8601String() : null,
    };
  }
}
