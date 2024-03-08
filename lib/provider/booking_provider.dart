// ignore_for_file: camel_case_types, public_member_api_docs

import 'dart:io';

import 'package:clinic/core/common/enums.dart';
import 'package:clinic/core/common/response.dart';
import 'package:clinic/data/data_servier.dart';
import 'package:clinic/models/bookings/bookings_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../core/common/query_helper.dart';

abstract class _BaseBookingProvider {
  Future<Map<String, dynamic>> addNewBooking({
    required BookingsModel bookingModel,
  });

  Future<Map<String, dynamic>> getAllBookings();

  Future<Map<String, dynamic>> deleteBookings({required List<String> ids});

  Future<Map<String, dynamic>> getBookingById({required String id});

  Future<Map<String, dynamic>> getBookingByBookingType({
    required List<String> status,
  });

  Future<Map<String, dynamic>> updateBooking({
    required Map<String, dynamic> booking,
    required String id,
  });
}

class BookingProviderImpl implements _BaseBookingProvider {
  final DatabaseService databaseService = DatabaseService();
  final getBookingQuery = [
    QueryHelper.lookup(
      form: 'users',
      field: 'doctor',
      fField: '_id',
    ),
    QueryHelper.lookup(
      form: 'users',
      field: 'references',
      fField: '_id',
    ),
    QueryHelper.lookup(
      form: 'medical_services',
      field: 'service',
      fField: '_id',
    ),
    {
      r'$unwind': r'$doctor',
    },
    {
      r'$unwind': r'$references',
    },
  ];

  @override
  Future<Map<String, dynamic>> addNewBooking({
    required BookingsModel bookingModel,
  }) async {
    var isValid = true;
    final errors = <String>[];
    if (bookingModel.doctor == null) {
      errors.add('doctor is required');
      isValid = false;
    }
    if (bookingModel.references == null) {
      errors.add('references is required');
      isValid = false;
    }
    if (bookingModel.services == null || bookingModel.services!.isEmpty) {
      errors.add('service is required');
      isValid = false;
    }
    if (bookingModel.paidPrice == null) {
      errors.add('price is required');
      isValid = false;
    }

    if (bookingModel.bookingStatus == null) {
      errors.add('status is required');
      isValid = false;
    }

    if (bookingModel.totalPrice == null) {
      errors.add('totalPrice is required');
      isValid = false;
    }

    if (!isValid) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'bad request',
        errorMessage: errors,
      );
    }

    try {
      // final serviceOb = await databaseService.medicalServicesCollection.findOne(
      //   where.id(
      //     ObjectId.parse(bookingModel.services!),
      //   ),
      // );
      //
      // final sPrice = double.parse(serviceOb!['price'] as String);
      // final inputPrice = double.parse(bookingModel.price!);
      // var statusOfPrice = ServicePriceStatus.done;
      // var partPrice = 0.0;
      // if (sPrice == inputPrice) {
      //   statusOfPrice = ServicePriceStatus.done;
      // } else if (inputPrice == 0) {
      //   statusOfPrice = ServicePriceStatus.notPaid;
      // } else {
      //   statusOfPrice = ServicePriceStatus.part;
      //   partPrice = sPrice - inputPrice;
      // }
      final getPriceNotPaid = num.parse(bookingModel.totalPrice!) -
          num.parse(bookingModel.paidPrice!);
      final inputPrice = num.parse(bookingModel.paidPrice!);
      var statusOfPrice = ServicePriceStatus.done;
      if (num.parse(bookingModel.totalPrice!) == inputPrice) {
        statusOfPrice = ServicePriceStatus.done;
      } else if (inputPrice == 0) {
        statusOfPrice = ServicePriceStatus.notPaid;
      } else {
        statusOfPrice = ServicePriceStatus.part;
      }
      bookingModel = bookingModel.copyWith(
        references: bookingModel.references,
        paidPrice: bookingModel.paidPrice,
        totalPrice: bookingModel.totalPrice,
        services: bookingModel.services,
        doctor: bookingModel.doctor,
        reviewTime: bookingModel.reviewTime,
        bookingStatus: bookingModel.bookingStatus,
        servicePriceStatus: statusOfPrice,
        bookingType: bookingModel.bookingType,
        partOfPrice: getPriceNotPaid.toString(),
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
      );

      // final doctorOb = await databaseService.userCollection.findOne(
      //   where.id(
      //     ObjectId.parse(bookingModel.doctor!),
      //   ),
      // );
      //
      // final patientOb = await databaseService.userCollection.findOne(
      //   where.id(
      //     ObjectId.parse(bookingModel.references!),
      //   ),
      // );
      //
      // final addData = bookingModel.toJson();
      // addData['doctor'] = doctorOb;
      // addData['service'] = serviceOb;
      // addData['references'] = patientOb;

      final r = await databaseService.bookingCollection.insertOne(
        Common.removeNullFromMap(bookingModel.toJson()),
      );

      return Common.sendSuccessResponse(
        statusCode: HttpStatus.ok.toString(),
        message: 'done add booking',
        data: r.document,
      );
    } catch (e) {
      Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'Undefined error',
        errorMessage: [
          e.toString(),
        ],
      );
    }
    return Common.sendErrorResponse(
      statusCode: HttpStatus.badRequest.toString(),
      message: 'Undefined error',
      errorMessage: [
        'error',
      ],
    );
  }

  @override
  Future<Map<String, dynamic>> getAllBookings() async {
    late List<Map<String, dynamic>> bookings;
    try {
      bookings = await databaseService.bookingCollection
          .modernAggregate(
            getBookingQuery,
          )
          .toList();
      return Common.sendSuccessResponse(
        statusCode: HttpStatus.ok.toString(),
        message: 'done get ${bookings.length} booking',
        data: bookings,
      );
    } catch (e) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'Undefined error',
        errorMessage: [
          e.toString(),
        ],
      );
    }
  }

  @override
  Future<Map<String, dynamic>> deleteBookings({
    required List<String> ids,
  }) async {
    List<ObjectId> ids0;
    try {
      ids0 = ids.map(ObjectId.parse).toList();
      final result = await databaseService.bookingCollection.deleteMany(
        {
          '_id': {
            r'$in': ids0,
          },
        },
      );
      return Common.sendSuccessResponse(
        statusCode: HttpStatus.ok.toString(),
        message: 'delete',
        data: {
          'status': 'delete ${result.nRemoved}',
        },
      );
    } catch (e) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'Undefined error',
        errorMessage: [
          e.toString(),
        ],
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getBookingById({required String id}) async {
    try {
      Map<String, dynamic>? booking;
      booking = await databaseService.bookingCollection.modernAggregate(
        [
          QueryHelper.match(
            field: '_id',
            query: {
              r'$eq': ObjectId.parse(id),
            },
          ),
          ...getBookingQuery,
        ],
      ).first;
      if (booking.isEmpty) {
        return Common.sendErrorResponse(
          statusCode: HttpStatus.badRequest.toString(),
          message: 'No booking with that $id}',
          errorMessage: [
            'Bad state: No element',
          ],
        );
      }
      return Common.sendSuccessResponse(
        statusCode: HttpStatus.ok.toString(),
        message: 'find booking',
        data: booking,
      );
    } catch (e) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'Undefined error',
        errorMessage: [
          e.toString(),
        ],
      );
    }
  }

  @override
  Future<Map<String, dynamic>> updateBooking({
    required Map<String, dynamic> booking,
    required String id,
  }) async {
    ObjectId oId;
    try {
      oId = ObjectId.parse(id);
      Map<String, dynamic>? updateBooking;
      updateBooking =
          await databaseService.bookingCollection.findOne(where.id(oId));
      // ignore: avoid_dynamic_calls
      if (booking['service_type'] != null) {
        return Common.sendErrorResponse(
          statusCode: HttpStatus.badRequest.toString(),
          message: 'bad state',
          errorMessage: [
            'can not update type',
          ],
        );
      }
      booking['id_number'] = updateBooking?['id_number'];

      final updateDocument = {
        r'$set': booking,
      };
      if (booking['booking_status'] != null) {
        $enumDecodeNullable(
          bookingStatusEnumMap,
          booking['booking_status'],
        );
      }
      if (booking['service_price_status'] != null) {
        $enumDecodeNullable(
          servicePriceEnumMap,
          booking['service_price_status'],
        );
      }
      if (booking['doctor'] != null) {
        final doctorOb = await databaseService.userCollection.findOne(
          where.id(
            ObjectId.parse(booking['doctor'] as String),
          ),
        );
        updateDocument[r'$set']?['doctor'] = doctorOb;
      }
      if (booking['references'] != null) {
        final patientOb = await databaseService.userCollection.findOne(
          where.id(
            ObjectId.parse(booking['references'] as String),
          ),
        );
        updateDocument[r'$set']?['references'] = patientOb;
      }
      if (booking['service'] != null) {
        final serviceOb =
            await databaseService.medicalServicesCollection.findOne(
          where.id(
            ObjectId.parse(booking['service'] as String),
          ),
        );
        updateDocument[r'$set']?['service'] = serviceOb;
      }

      updateDocument[r'$set']?['updated_at'] = DateTime.now().toIso8601String();

      await databaseService.bookingCollection.updateOne(
        where.id(oId),
        updateDocument,
      );
      final result =
          await databaseService.bookingCollection.findOne(where.id(oId));
      return Common.sendSuccessResponse(
        statusCode: HttpStatus.ok.toString(),
        message: 'Updated booking',
        data: result,
      );
    } catch (e) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'Undefined error',
        errorMessage: [
          e.toString(),
        ],
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getBookingByBookingType({
    required List<String> status,
  }) async {
    try {
      for (final element in status) {
        $enumDecodeNullable(
          bookingStatusEnumMap,
          element,
        );
      }
      final result = await databaseService.bookingCollection.modernAggregate(
        [
          QueryHelper.match(
            field: 'booking_status',
            query: {
              r'$in': status,
            },
          ),
          ...getBookingQuery,
        ],
      ).toList();
      return Common.sendSuccessResponse(
        statusCode: HttpStatus.ok.toString(),
        message: 'find ${result.length} booking for $status type',
        data: result,
      );
    } catch (e) {
      return Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'bad state',
        errorMessage: [
          e.toString(),
        ],
      );
    }
  }
}
