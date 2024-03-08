// ignore_for_file: no_default_cases

import 'package:clinic/core/common/response.dart';
import 'package:clinic/data/data_servier.dart';
import 'package:clinic/provider/common_provider.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) {
  return DatabaseService().startConnection(context, _commonHandler(context));
}

Future<Response> _commonHandler(RequestContext context) async {
  final method = context.request.method;
  switch (method) {
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.get:
      return _get(context);
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
  final prov = context.read<CommonProvider>();
  final bodyData = await context.request.json() as Map<String, dynamic>;
  final sedResponse = await prov.addNewDiseaseOrWarning(
    bodyData: bodyData,
    type: 'warning',
  );
  return Response.json(
    statusCode: int.parse(sedResponse['status_code'] as String),
    body: sedResponse,
  );
}

Future<Response> _get(RequestContext context) async {
  final prov = context.read<CommonProvider>();
  final sedResponse = await prov.getCommon(
    type: 'warning',
  );
  return Response.json(
    statusCode: int.parse(sedResponse['status_code'] as String),
    body: sedResponse,
  );
}
