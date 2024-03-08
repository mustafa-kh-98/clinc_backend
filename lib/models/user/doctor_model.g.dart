// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
      workStartDate: json['work_start_date'] == null
          ? null
          : DateTime.parse(json['work_start_date'] as String),
      salary: json['salary'] as String?,
      medicalSpecialization: json['medical_specialization'] as String?,
    );

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'work_start_date': instance.workStartDate?.toIso8601String(),
      'salary': instance.salary,
      'medical_specialization': instance.medicalSpecialization,
    };
