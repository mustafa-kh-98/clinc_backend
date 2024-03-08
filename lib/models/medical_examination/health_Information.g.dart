// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_Information.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthInformationModel _$HealthInformationModelFromJson(
        Map<String, dynamic> json) =>
    HealthInformationModel(
      chronicDiseasesId: (json['chronic_diseases'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      healthWarningsId: (json['health_warnings'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$HealthInformationModelToJson(
        HealthInformationModel instance) =>
    <String, dynamic>{
      'chronic_diseases': instance.chronicDiseasesId,
      'health_warnings': instance.healthWarningsId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

CommonAndWarningsDiseasesModel _$CommonAndWarningsDiseasesModelFromJson(
        Map<String, dynamic> json) =>
    CommonAndWarningsDiseasesModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CommonAndWarningsDiseasesModelToJson(
        CommonAndWarningsDiseasesModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
