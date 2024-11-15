// domain/entities/post.dart

class RequestEntity {
  String? id;
  double? latitude;
  double? longitude;
  String? address;
  DateTime? date;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? status;
  String? description;
  String? blood;
  String? userId;
  String? file;
  String? donorId;

  RequestEntity({
    this.id,
    this.latitude,
    this.longitude,
    this.address,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.description,
    this.blood,
    this.userId,
    this.file,
    this.donorId,
  });
}
