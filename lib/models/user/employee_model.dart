// ignore_for_file: public_member_api_docs

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'employee_model.g.dart';

@immutable
@JsonSerializable()
class EmployeeModel {
  const EmployeeModel({
    this.workStartDate,
    this.salary,
    this.jopTitle,
  });

  @JsonKey(name: 'work_start_date')
  final DateTime? workStartDate;
  final String? salary;
  @JsonKey(name: 'jop_title')
  final String? jopTitle;

  EmployeeModel copyWith({
    DateTime? workStartDate,
    String? salary,
    String? jopTitle,
  }) {
    return EmployeeModel(
      jopTitle: jopTitle,
      workStartDate: workStartDate,
      salary: salary,
    );
  }

  static EmployeeModel fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);
}
