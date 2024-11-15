import '../../domain/entities/blood_entity.dart';

class BloodState {}

class BloodInitial extends BloodState {}

class BloodLoading extends BloodState {}

class BloodLoaded extends BloodState {
  final List<BloodEntity> bloods;

  BloodLoaded({required this.bloods});
}

class BloodFailure extends BloodState {
  final String error;
  BloodFailure(this.error);
}
