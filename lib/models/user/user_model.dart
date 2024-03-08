// ignore_for_file: public_member_api_docs

import 'package:clinic/models/user/employee_model.dart';
import 'package:clinic/models/user/patient_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'doctor_model.dart';

part 'user_model.g.dart';

@immutable
@JsonSerializable()
class UserModel extends Equatable {
  const UserModel({
    this.name,
    this.birthDay,
    this.gender,
    this.phone,
    this.userName,
    this.email,
    this.image,
    this.address,
    this.employee,
    this.createdAt,
    this.updatedAt,
    this.doctor,
    this.patient,
    this.userType,
  });

  final String? name;
  final String? phone;

  @JsonKey(name: 'user_type')
  final List<String>? userType;

  @JsonKey(name: 'user_name')
  final String? userName;
  final String? gender;
  final String? address;

  @JsonKey(name: 'birth_day')
  final DateTime? birthDay;
  final String? email;
  final String? image;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final EmployeeModel? employee;

  final DoctorModel? doctor;
  final PatientModel? patient;

  UserModel copyWith({
    String? name,
    String? phone,
    DateTime? birthDay,
    String? gender,
    String? userName,
    String? address,
    String? image,
    String? email,
    EmployeeModel? employeeModel,
    DoctorModel? doctorModel,
    PatientModel? patient,
    List<String>? userType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      phone: phone,
      birthDay: birthDay,
      name: name,
      gender: gender,
      userName: userName,
      email: email,
      image: image,
      address: address,
      employee: employeeModel,
      doctor: doctorModel,
      patient: patient,
      userType: userType,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static UserModel fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [
        name,
        userName,
        phone,
        birthDay,
        gender,
        email,
        image,
        address,
        employee,
      ];
}
