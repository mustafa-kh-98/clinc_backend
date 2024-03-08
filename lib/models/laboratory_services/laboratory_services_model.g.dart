// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'laboratory_services_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaboratoryServicesModel _$LaboratoryServicesModelFromJson(
        Map<String, dynamic> json) =>
    LaboratoryServicesModel(
      idNumber: json['id_number'] as int?,
      serviceType: $enumDecodeNullable(
          _$LaboratoryServiceTypesEnumMap, json['service_type']),
      serviceName: json['service_name'] as String?,
      price: json['price'] as String?,
      notes: json['notes'] as String?,
      icon: json['icon'] as String?,
      results:
          (json['results'] as List<dynamic>?)?.map((e) => e as String).toList(),
      companyName: json['company_name'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$LaboratoryServicesModelToJson(
        LaboratoryServicesModel instance) =>
    <String, dynamic>{
      'id_number': instance.idNumber,
      'service_name': instance.serviceName,
      'company_name': instance.companyName,
      'service_type': _$LaboratoryServiceTypesEnumMap[instance.serviceType],
      'price': instance.price,
      'notes': instance.notes,
      'icon': instance.icon,
      'results': instance.results,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$LaboratoryServiceTypesEnumMap = {
  LaboratoryServiceTypes.ray: 'ray',
  LaboratoryServiceTypes.test: 'test',
  LaboratoryServiceTypes.medicine: 'medicine',
};
