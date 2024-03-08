// ignore_for_file: public_member_api_docs

import 'package:clinic/models/medical_examination/more_information.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'patient_model.g.dart';

@immutable
@JsonSerializable()
class PatientModel {
  const PatientModel({
    this.registrationDate,
    this.additionalInformation,
  });

  @JsonKey(name: 'registration_date')
  final DateTime? registrationDate;

  @JsonKey(name: 'additional_information')
  final String? additionalInformation;

  PatientModel copyWith({
    DateTime? registrationDate,
    ObjectId? additionalInformation,
  }) {
    return PatientModel(
      registrationDate: registrationDate,
      additionalInformation: additionalInformation?.oid,
    );
  }

  static PatientModel fromJson(Map<String, dynamic> json) =>
      _$PatientModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatientModelToJson(this);
}
