import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vivamais/src/core/api/firebase_const.dart';

import '../../domain/entities/blood_entity.dart';
import 'i_blood_datasource.dart';

class FirebaseBloodDatasource extends IFirebaseBloodDatasource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FirebaseBloodDatasource({required this.firestore, required this.auth});

  @override
  Stream<List<BloodEntity>> fetchBloods() {
    final bloods =
        firestore.collection(FirebaseConst.blood).snapshots().map((snapshot) {
      // Calcula o total de usuários
      num totalUsers = snapshot.docs.fold(
        0,
        (sum, doc) => sum + num.parse(doc['qtd_users'].toString()),
      );

      // Mapeia e cria a lista de BloodEntity
      List<BloodEntity> bloodEntities = snapshot.docs.map((doc) {
        int qtdUsers = doc['qtd_users'];
        String type = doc['type'];

        // Calcula a percentagem com uma casa decimal
        double percentage = (totalUsers > 0)
            ? double.parse(((qtdUsers / totalUsers) * 100).toStringAsFixed(1))
            : 0.0;

        return BloodEntity(
          type: type,
          qtdUsers: qtdUsers,
          percentage: percentage,
        );
      }).toList();

      // Ordena a lista pela percentagem, da maior para a menor
      bloodEntities.sort((a, b) => b.percentage.compareTo(a.percentage));

      return bloodEntities;
    });

    return bloods;
  }
}
