// ignore_for_file: no_default_cases

import 'dart:convert';
import 'dart:io';

import 'package:clinic/core/common/response.dart';
import 'package:clinic/data/data_servier.dart';
import 'package:clinic/models/bookings/bookings_model.dart';
import 'package:clinic/provider/booking_provider.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) {
  return DatabaseService().startConnection(context, _bookingHandler(context));
}

Future<Response> _bookingHandler(RequestContext context) async {
  final method = context.request.method;
  switch (method) {
    case HttpMethod.delete:
      return _delete(context);
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
    default:
      return Response.json(
        statusCode: 404,
        body: Common.sendErrorResponse(
          statusCode: '404',
          message: 'Method not allowed',
          errorMessage: [
            'Method ${context.request.method.name} not allowed',
          ],
        ),
      );
  }
}

Future<Response> _post(RequestContext context) async {
  final prov = context.read<BookingProviderImpl>();
  final bodyData = await context.request.json() as Map<String, dynamic>;
  BookingsModel? bookingsModel;
  try {
    bookingsModel = BookingsModel.fromJson(bodyData);
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'Bad request',
        errorMessage: [
          e.toString(),
        ],
      ),
    );
  }
  final sedResponse = await prov.addNewBooking(
    bookingModel: bookingsModel,
  );
  return Response.json(
    statusCode: int.parse(sedResponse['status_code'] as String),
    body: sedResponse,
  );
}

Future<Response> _get(RequestContext context) async {
  final param = context.request.uri.queryParametersAll;
  final prov = context.read<BookingProviderImpl>();
  if (param.isNotEmpty) {
    final sedResponse = await prov.getBookingByBookingType(
      status: param['status']!,
    );
    return Response.json(
      statusCode: int.parse(sedResponse['status_code'] as String),
      body: sedResponse,
    );
  }
  final sedResponse = await prov.getAllBookings();
  return Response.json(
    statusCode: int.parse(sedResponse['status_code'] as String),
    body: sedResponse,
  );
}

Future<Response> _delete(RequestContext context) async {
  final prov = context.read<BookingProviderImpl>();
  final ids0 = await context.request.body();
  List<String>? ids;

  try {
    final toJson = jsonDecode(ids0);
    final dynamicIds = toJson['ids'];

    if (dynamicIds is List) {
      ids = dynamicIds.map((dynamicId) => dynamicId.toString()).toList();
    } else {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: Common.sendErrorResponse(
          statusCode: HttpStatus.badRequest.toString(),
          message: 'Bad request',
          errorMessage: [
            'Invalid format for ids',
          ],
        ),
      );
    }
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: Common.sendErrorResponse(
        statusCode: HttpStatus.badRequest.toString(),
        message: 'Bad request',
        errorMessage: [
          e.toString(),
        ],
      ),
    );
  }
  final sedResponse = await prov.deleteBookings(ids: ids);
  return Response.json(
    statusCode: int.parse(sedResponse['status_code'] as String),
    body: sedResponse,
  );
}
