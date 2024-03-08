// ignore_for_file: public_member_api_docs

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'doctor_model.g.dart';

@immutable
@JsonSerializable()
class DoctorModel {
  const DoctorModel({
    this.workStartDate,
    this.salary,
    this.medicalSpecialization,
  });

  @JsonKey(name: 'work_start_date')
  final DateTime? workStartDate;
  final String? salary;
  @JsonKey(name: 'medical_specialization')
  final String? medicalSpecialization;

  DoctorModel copyWith({
    DateTime? workStartDate,
    String? salary,
    String? medicalSpecialization,
  }) {
    return DoctorModel(
      medicalSpecialization: medicalSpecialization,
      workStartDate: workStartDate,
      salary: salary,
    );
  }

  static DoctorModel fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}
