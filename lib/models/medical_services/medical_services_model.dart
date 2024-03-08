// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'medical_services_model.g.dart';

@immutable
@JsonSerializable()
class MedicalServicesModel extends Equatable {
  const MedicalServicesModel({
    this.idNumber,
    this.serviceName,
    this.price,
    this.notes,
    this.icon,
    // this.doctor,
    this.createdAt,
    this.updatedAt,
  });

  @JsonKey(name: 'id_number')
  final int? idNumber;
  @JsonKey(name: 'service_name')
  final String? serviceName;
  // final String? doctor;
  final String? price;
  final String? notes;
  final String? icon;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  MedicalServicesModel copyWith({
    int? idNumber,
    String? serviceName,
    String? price,
    String? notes,
    String? icon,
    String? doctor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicalServicesModel(
      idNumber: idNumber,
      notes: notes,
      icon: icon,
      price: price,
      serviceName: serviceName,
      // doctor: doctor,
      updatedAt: updatedAt,
      createdAt: createdAt,
    );
  }

  static MedicalServicesModel fromJson(Map<String, dynamic> json) =>
      _$MedicalServicesModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalServicesModelToJson(this);

  @override
  List<Object?> get props => [
        idNumber,
        serviceName,
        // doctor,
        price,
        notes,
        icon,
        createdAt,
        updatedAt,
      ];
}
