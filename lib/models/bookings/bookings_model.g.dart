// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingsModel _$BookingsModelFromJson(Map<String, dynamic> json) =>
    BookingsModel(
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      paidPrice: json['paid_price'] as String?,
      totalPrice: json['total_price'] as String?,
      partOfPrice: json['part_of_price'] as String?,
      bookingType: json['booking_type'] as String?,
      references: json['references'] as String?,
      bookingStatus:
          $enumDecodeNullable(_$BookingStatusEnumMap, json['booking_status']),
      doctor: json['doctor'] as String?,
      servicePriceStatus: $enumDecodeNullable(
          _$ServicePriceStatusEnumMap, json['service_price_status']),
      reviewTime: json['review_time'] == null
          ? null
          : DateTime.parse(json['review_time'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$BookingsModelToJson(BookingsModel instance) =>
    <String, dynamic>{
      'doctor': instance.doctor,
      'references': instance.references,
      'services': instance.services,
      'booking_status': _$BookingStatusEnumMap[instance.bookingStatus],
      'review_time': instance.reviewTime?.toIso8601String(),
      'booking_type': instance.bookingType,
      'paid_price': instance.paidPrice,
      'total_price': instance.totalPrice,
      'service_price_status':
          _$ServicePriceStatusEnumMap[instance.servicePriceStatus],
      'part_of_price': instance.partOfPrice,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$BookingStatusEnumMap = {
  BookingStatus.done: 'done',
  BookingStatus.inProgress: 'inProgress',
  BookingStatus.inDoctor: 'inDoctor',
  BookingStatus.notCome: 'notCome',
};

const _$ServicePriceStatusEnumMap = {
  ServicePriceStatus.done: 'done',
  ServicePriceStatus.part: 'part',
  ServicePriceStatus.notPaid: 'notPaid',
};
