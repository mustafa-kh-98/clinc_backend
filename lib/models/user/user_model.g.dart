// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      name: json['name'] as String?,
      birthDay: json['birth_day'] == null
          ? null
          : DateTime.parse(json['birth_day'] as String),
      gender: json['gender'] as String?,
      phone: json['phone'] as String?,
      userName: json['user_name'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      address: json['address'] as String?,
      employee: json['employee'] == null
          ? null
          : EmployeeModel.fromJson(json['employee'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      doctor: json['doctor'] == null
          ? null
          : DoctorModel.fromJson(json['doctor'] as Map<String, dynamic>),
      patient: json['patient'] == null
          ? null
          : PatientModel.fromJson(json['patient'] as Map<String, dynamic>),
      userType: (json['user_type'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'user_type': instance.userType,
      'user_name': instance.userName,
      'gender': instance.gender,
      'address': instance.address,
      'birth_day': instance.birthDay?.toIso8601String(),
      'email': instance.email,
      'image': instance.image,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'employee': instance.employee,
      'doctor': instance.doctor,
      'patient': instance.patient,
    };
