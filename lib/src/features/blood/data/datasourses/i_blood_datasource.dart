import '../../domain/entities/blood_entity.dart';

abstract class IFirebaseBloodDatasource {
  Stream<List<BloodEntity>> fetchBloods();
}
