// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_services_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalServicesModel _$MedicalServicesModelFromJson(
        Map<String, dynamic> json) =>
    MedicalServicesModel(
      idNumber: json['id_number'] as int?,
      serviceName: json['service_name'] as String?,
      price: json['price'] as String?,
      notes: json['notes'] as String?,
      icon: json['icon'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MedicalServicesModelToJson(
        MedicalServicesModel instance) =>
    <String, dynamic>{
      'id_number': instance.idNumber,
      'service_name': instance.serviceName,
      'price': instance.price,
      'notes': instance.notes,
      'icon': instance.icon,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
