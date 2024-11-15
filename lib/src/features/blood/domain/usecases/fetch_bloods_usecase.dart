import 'package:vivamais/src/features/blood/domain/repositories/i_blood_repository.dart';

import '../entities/blood_entity.dart';

class FetchBloodsUsecase {
  final IBloodRepository repository;

  FetchBloodsUsecase({required this.repository});

  Stream<List<BloodEntity>> call() {
    return repository.fetchBloods();
  }
}
