// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'more_information.g.dart';

@immutable
@JsonSerializable()
class AdditionalInformationModel extends Equatable {
  const AdditionalInformationModel({
    this.info,
  });

  final List<InformationModel>? info;

  static AdditionalInformationModel fromJson(Map<String, dynamic> json) =>
      _$AdditionalInformationModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdditionalInformationModelToJson(this);

  @override
  List<Object?> get props => [info];
}

@immutable
@JsonSerializable()
class InformationModel {
  const InformationModel({
    required this.id,
    this.title,
    this.type,
    this.value,
  });

  final String id;
  final String? title;
  final String? type;
  final dynamic value;

  InformationModel copyWith(
    String? title,
    String? value,
    String? type,
      String id,
  ) {
    return InformationModel(
      id: id,
      type: type,
      title: title,
      value: value,
    );
  }

  static InformationModel fromJson(Map<String, dynamic> json) =>
      _$InformationModelFromJson(json);

  Map<String, dynamic> toJson() => _$InformationModelToJson(this);
}
