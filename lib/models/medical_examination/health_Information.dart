// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'health_Information.g.dart';

@immutable
@JsonSerializable()
class HealthInformationModel extends Equatable {
  const HealthInformationModel({
    this.chronicDiseasesId,
    this.healthWarningsId,
    this.createdAt,
    this.updatedAt,
  });

  @JsonKey(name: 'chronic_diseases')
  final List<String>? chronicDiseasesId;
  @JsonKey(name: 'health_warnings')
  final List<String>? healthWarningsId;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  HealthInformationModel copyWith({
    List<String>? chronicDiseases,
    List<String>? healthWarnings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HealthInformationModel(
      chronicDiseasesId: chronicDiseases,
      healthWarningsId: healthWarnings,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static HealthInformationModel fromJson(Map<String, dynamic> json) =>
      _$HealthInformationModelFromJson(json);

  Map<String, dynamic> toJson() => _$HealthInformationModelToJson(this);

  @override
  List<Object?> get props => [
        chronicDiseasesId,
        healthWarningsId,
      ];
}

@immutable
@JsonSerializable()
class CommonAndWarningsDiseasesModel {
  const CommonAndWarningsDiseasesModel({
    this.title,
    this.description,
    this.type,
    this.updatedAt,
    this.createdAt,
  });

  final String? title;
  final String? description;
  final String? type;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  static CommonAndWarningsDiseasesModel fromJson(Map<String, dynamic> json) =>
      _$CommonAndWarningsDiseasesModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommonAndWarningsDiseasesModelToJson(this);

  CommonAndWarningsDiseasesModel copyWith({
    String? title,
    String? description,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommonAndWarningsDiseasesModel(
      title: title,
      description: description,
      type: type,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
