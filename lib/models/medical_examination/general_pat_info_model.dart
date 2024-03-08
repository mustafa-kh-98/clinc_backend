// ignore_for_file: public_member_api_docs

import 'package:clinic/models/medical_examination/health_Information.dart';
import 'package:clinic/models/medical_examination/more_information.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'general_pat_info_model.g.dart';

@immutable
@JsonSerializable()
class GeneralInfoModel extends Equatable {
  const GeneralInfoModel({
    this.healthInformation,
    this.patientId,
  });

  final String? patientId;
  final HealthInformationModel? healthInformation;

  GeneralInfoModel copyWith({
    String? patientId,
    HealthInformationModel? healthInformation,
    AdditionalInformationModel? additionalInformation,
  }) {
    return GeneralInfoModel(
      healthInformation: healthInformation,
      patientId: patientId,
    );
  }
  static GeneralInfoModel fromJson(Map<String, dynamic> json) =>
      _$GeneralInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeneralInfoModelToJson(this);

  @override
  List<Object?> get props => [
        patientId,
        healthInformation,
      ];
}
