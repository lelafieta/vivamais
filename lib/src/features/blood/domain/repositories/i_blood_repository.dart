import '../entities/blood_entity.dart';

abstract class IBloodRepository {
  Stream<List<BloodEntity>> fetchBloods();
}
