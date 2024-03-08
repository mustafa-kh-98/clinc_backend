import 'dart:convert';
import 'dart:io';

import 'package:clinic/core/common/response.dart';
import 'package:clinic/data/data_servier.dart';
import 'package:clinic/provider/laboratory_services_provider.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) {
  return DatabaseService()
      .startConnection(context, _dynamicHandler(context, id));
}

Future<Response> _dynamicHandler(RequestContext context, String id) async {
  if (context.request.method == HttpMethod.get) {
    return _get(context, id);
  }
  if (context.request.method == HttpMethod.put) {
    return _put(context, id);
  }
  return Response.json(
    statusCode: 404,
    body: Common.sendErrorResponse(
      statusCode: '404',
      message: 'Method not allowed',
      errorMessage: [
        'Method ${context.request.method.value} not allowed',
      ],
    ),
  );
}

Future<Response> _get(RequestContext context, String id) async {
  final prov = LaboratoryServicesProviderImpl();
  final sedResponse = await prov.getServiceById(id: id);
  return Response.json(
    statusCode: int.parse(sedResponse['status_code'] as String),
    body: sedResponse,
  );
}

Future<Response> _put(RequestContext context, String id) async {
  final prov = LaboratoryServicesProviderImpl();
  final bodyData = await context.request.body();
  Map<String, dynamic>? jsonData;
  try {
    jsonData = jsonDecode(bodyData) as Map<String, dynamic>;
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
  final sedResponse = await prov.updateService(
    service: jsonData,
    id: id,
  );
  return Response.json(
    statusCode: int.parse(sedResponse['status_code'] as String),
    body: sedResponse,
  );
}
