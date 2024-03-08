// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    EmployeeModel(
      workStartDate: json['work_start_date'] == null
          ? null
          : DateTime.parse(json['work_start_date'] as String),
      salary: json['salary'] as String?,
      jopTitle: json['jop_title'] as String?,
    );

Map<String, dynamic> _$EmployeeModelToJson(EmployeeModel instance) =>
    <String, dynamic>{
      'work_start_date': instance.workStartDate?.toIso8601String(),
      'salary': instance.salary,
      'jop_title': instance.jopTitle,
    };
