// ignore_for_file: public_member_api_docs

import 'package:clinic/core/common/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'laboratory_services_model.g.dart';

@immutable
@JsonSerializable()
class LaboratoryServicesModel extends Equatable {
  const LaboratoryServicesModel({
    this.idNumber,
    this.serviceType,
    this.serviceName,
    this.price,
    this.notes,
    this.icon,
    this.results,
    this.companyName,
    this.createdAt,
    this.updatedAt,
  });

  @JsonKey(name: 'id_number')
  final int? idNumber;
  @JsonKey(name: 'service_name')
  final String? serviceName;
  @JsonKey(name: 'company_name')
  final String? companyName;
  @JsonKey(name: 'service_type')
  final LaboratoryServiceTypes? serviceType;
  final String? price;
  final String? notes;
  final String? icon;
  final List<String>? results;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  String typeName(LaboratoryServiceTypes key) =>
      laboratoryServiceTypesEnumMap[key]!;

  LaboratoryServicesModel copyWith({
    int? idNumber,
    LaboratoryServiceTypes? serviceType,
    String? serviceName,
    String? price,
    String? notes,
    String? icon,
    List<String>? results,
    String? companyName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LaboratoryServicesModel(
      idNumber: idNumber,
      notes: notes,
      icon: icon,
      price: price,
      serviceName: serviceName,
      results: results,
      serviceType: serviceType,
      companyName: companyName,
      updatedAt: updatedAt,
      createdAt: createdAt,
    );
  }

  static LaboratoryServicesModel fromJson(Map<String, dynamic> json) =>
      _$LaboratoryServicesModelFromJson(json);

  Map<String, dynamic> toJson() => _$LaboratoryServicesModelToJson(this);

  @override
  List<Object?> get props => [
        idNumber,
        serviceName,
        price,
        notes,
        icon,
        results,
        createdAt,
        updatedAt,
      ];
}
