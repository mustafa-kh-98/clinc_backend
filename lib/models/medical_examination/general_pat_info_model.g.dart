// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_pat_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralInfoModel _$GeneralInfoModelFromJson(Map<String, dynamic> json) =>
    GeneralInfoModel(
      healthInformation: json['healthInformation'] == null
          ? null
          : HealthInformationModel.fromJson(
              json['healthInformation'] as Map<String, dynamic>),
      patientId: json['patientId'] as String?,
    );

Map<String, dynamic> _$GeneralInfoModelToJson(GeneralInfoModel instance) =>
    <String, dynamic>{
      'patientId': instance.patientId,
      'healthInformation': instance.healthInformation,
    };
