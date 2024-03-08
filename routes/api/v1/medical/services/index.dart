// ignore_for_file: no_default_cases

import 'dart:convert';
import 'dart:io';

import 'package:clinic/core/common/response.dart';
import 'package:clinic/data/data_servier.dart';
import 'package:clinic/models/medical_services/medical_services_model.dart';
import 'package:clinic/provider/medical_services_provider.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) {
  return DatabaseService().startConnection(context, _serviceHandler(context));
}

Future<Response> _serviceHandler(RequestContext context) async {
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
  final prov = context.read<MedicalServicesProviderImpl>();
  final bodyData = await context.request.json() as Map<String, dynamic>;
  MedicalServicesModel? serviceModel;
  try {
    serviceModel = MedicalServicesModel.fromJson(bodyData);
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
  final sedResponse = await prov.addAnService(
    medicalServicesModel: serviceModel,
  );
  return Response.json(
    statusCode: int.parse(sedResponse['status_code'] as String),
    body: sedResponse,
  );
}

Future<Response> _get(RequestContext context) async {
  final prov = context.read<MedicalServicesProviderImpl>();
  final sedResponse = await prov.getAllServices();
  return Response.json(
    statusCode: int.parse(sedResponse['status_code'] as String),
    body: sedResponse,
  );
}

Future<Response> _delete(RequestContext context) async {
  final prov = context.read<MedicalServicesProviderImpl>();
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
  final sedResponse = await prov.deleteServices(ids: ids);
  return Response.json(
    statusCode: int.parse(sedResponse['status_code'] as String),
    body: sedResponse,
  );
}
