// ignore_for_file: no_default_cases

import 'dart:io';

import 'package:clinic/core/common/response.dart';
import 'package:clinic/data/data_servier.dart';
import 'package:clinic/provider/medical_examination_provider.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) {
  return DatabaseService()
      .startConnection(context, _medicalExaminationHandler(context));
}

Future<Response> _medicalExaminationHandler(RequestContext context) async {
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

Future<Response> _get(RequestContext context) async {
  final param = context.request.uri.queryParametersAll;
  final prov = context.read<MedicalExaminationProvider>();
  if (param.isNotEmpty) {}
  final sedResponse = await prov.getAllPatMedicalInfo(
    patId: param['pat']?.first,
  );
  return Response.json(
    statusCode: int.parse(sedResponse['status_code'] as String),
    body: sedResponse,
  );
}

Future<Response> _post(RequestContext context) async {
  final param = context.request.uri.queryParametersAll;
  final body = await context.request.json() as Map<String, dynamic>;
  final prov = context.read<MedicalExaminationProvider>();
  if (param.isEmpty || !param.keys.contains('type')) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: Common.sendErrorResponse(
        statusCode: '400',
        message: 'Bad State',
        errorMessage: [
          '$param params must have type {info,disease,warning}',
        ],
      ),
    );
  }
  final type = param['type']!.first;
  switch (type) {
    case 'info':
      {
        final sedResponse = await prov.addOrUpdateInfoForPat(
          exId: param['ex']!.first,
          infoId: param['info']?.first,
          body: body,
        );
        return Response.json(
          statusCode: int.parse(sedResponse['status_code'] as String),
          body: sedResponse,
        );
      }
    default:
      {
        final sedResponse = await prov.addOrUpdateDWForPat(
          exId: param['ex']!.first,
          body: body,
        );
        return Response.json(
          statusCode: int.parse(sedResponse['status_code'] as String),
          body: sedResponse,
        );
      }
  }
}

Future<Response> _delete(RequestContext context) async {
  final param = context.request.uri.queryParametersAll;
  final prov = context.read<MedicalExaminationProvider>();
  if (param.keys.contains('ex')) {
    final sedResponse = await prov.deleteInfoForPat(
      exId: param['ex']!.first,
      infoId: param['info']!.first,
    );
    return Response.json(
      statusCode: int.parse(sedResponse['status_code'] as String),
      body: sedResponse,
    );
  }

  return Response.json();
}
