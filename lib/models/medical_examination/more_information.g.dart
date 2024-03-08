// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'more_information.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdditionalInformationModel _$AdditionalInformationModelFromJson(
        Map<String, dynamic> json) =>
    AdditionalInformationModel(
      info: (json['info'] as List<dynamic>?)
          ?.map((e) => InformationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AdditionalInformationModelToJson(
        AdditionalInformationModel instance) =>
    <String, dynamic>{
      'info': instance.info,
    };

InformationModel _$InformationModelFromJson(Map<String, dynamic> json) =>
    InformationModel(
      id: json['id'] as String,
      title: json['title'] as String?,
      type: json['type'] as String?,
      value: json['value'],
    );

Map<String, dynamic> _$InformationModelToJson(InformationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'value': instance.value,
    };
