// ignore_for_file: public_member_api_docs

import 'package:clinic/core/common/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'bookings_model.g.dart';

@immutable
@JsonSerializable()
class BookingsModel extends Equatable {
  const BookingsModel({
    this.services,
    this.paidPrice,
    this.totalPrice,
    this.partOfPrice,
    this.bookingType,
    this.references,
    this.bookingStatus,
    this.doctor,
    this.servicePriceStatus,
    this.reviewTime,
    this.createdAt,
    this.updatedAt,
  });

  final String ? doctor;
  final String ? references;
  final List<String> ? services;

  @JsonKey(name: 'booking_status')
  final BookingStatus? bookingStatus;

  @JsonKey(name: 'review_time')
  final DateTime? reviewTime;

  @JsonKey(name: 'booking_type')
  final String? bookingType;

  @JsonKey(name: 'paid_price')
  final String? paidPrice;

  @JsonKey(name: 'total_price')
  final String? totalPrice;

  @JsonKey(name: 'service_price_status')
  final ServicePriceStatus? servicePriceStatus;


  @JsonKey(name: 'part_of_price')
  final String? partOfPrice;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;


  BookingsModel copyWith({
    String? paidPrice,
    String? totalPrice,
    BookingStatus? bookingStatus,
    ServicePriceStatus? servicePriceStatus,
    DateTime? reviewTime,
    String? references,
    String? doctor,
    List<String>? services,
    String? bookingType,
    String? partOfPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingsModel(
      paidPrice: paidPrice,
      totalPrice: totalPrice,
      doctor: doctor,
      services: services,
      references: references,
      bookingStatus: bookingStatus,
      reviewTime: reviewTime,
      servicePriceStatus: servicePriceStatus,
      bookingType: bookingType,
      partOfPrice: partOfPrice,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static BookingsModel fromJson(Map<String, dynamic> json) =>
      _$BookingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingsModelToJson(this);

  @override
  List<Object?> get props =>
      [
        services,
        paidPrice,
        totalPrice,
        references,
        bookingStatus,
        servicePriceStatus,
        doctor,
        reviewTime,
        createdAt,
        updatedAt,
      ];
}
