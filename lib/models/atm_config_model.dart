class AtmConfigModel {
  int id;
  int minValue;
  int medValue;
  int medValuePri;
  int maxValue;
  int minValEmiss;
  String createdAt;
  String updatedAt;

  AtmConfigModel({
    required this.id,
    required this.minValue,
    required this.medValue,
    required this.medValuePri,
    required this.maxValue,
    required this.minValEmiss,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AtmConfigModel.fromJson(Map<String, dynamic> json) {
    return AtmConfigModel(
      id: json['id'],
      minValue: json['min_value'],
      medValue: json['med_value'],
      medValuePri: json['med_value_pri'],
      maxValue: json['max_value'],
      minValEmiss: json['min_val_emiss'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'min_value': minValue,
      'med_value': medValue,
      'med_value_pri': medValuePri,
      'max_value': maxValue,
      'min_val_emiss': minValEmiss,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
