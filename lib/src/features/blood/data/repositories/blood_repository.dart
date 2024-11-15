import 'package:vivamais/src/features/blood/data/datasourses/i_blood_datasource.dart';
import 'package:vivamais/src/features/blood/domain/repositories/i_blood_repository.dart';

import '../../domain/entities/blood_entity.dart';

class BloodRepository extends IBloodRepository {
  final IFirebaseBloodDatasource bloodDatasource;

  BloodRepository({required this.bloodDatasource});

  @override
  Stream<List<BloodEntity>> fetchBloods() {
    return bloodDatasource.fetchBloods();
  }
}
