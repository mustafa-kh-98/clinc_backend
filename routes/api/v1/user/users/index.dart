import 'dart:convert';
import 'dart:io';

import 'package:clinic/core/common/response.dart';
import 'package:clinic/data/data_servier.dart';
import 'package:clinic/provider/user_provider.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) {
  return DatabaseService().startConnection(context, _usersHandler(context));
}

Future<Response> _usersHandler(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    return _get(context);
  }
  if (context.request.method == HttpMethod.post) {
    return _post(context);
  }
  if (context.request.method == HttpMethod.delete) {
    return _delete(context);
  }
  return Response.json(
    statusCode: 404,
    body: Common.sendErrorResponse(
      statusCode: '404',
      message: 'Method not allowed',
      errorMessage: [
        'Method ${context.request.method} not allowed',
      ],
    ),
  );
}

Future<Response> _get(RequestContext context) async {
  final paramsList = context.request.uri.queryParametersAll;
  final prov = context.read<UserProviderImpl>();
  if (paramsList.containsKey('page')) {
    final page = paramsList['page']?.first is String
        ? int.parse(paramsList['page']?.first ?? '1')
        : paramsList['page']?.first ?? 1;
    final limit = paramsList['limit']?.first is String
        ? int.parse(paramsList['limit']?.first ?? '1')
        : paramsList['page']?.first ?? 1;
    final sedResponse = await prov.fetchAllUsers(
      page: page as int,
      limit: limit as int,
    );
    return Response.json(
      statusCode: int.parse(sedResponse['status_code'] as String),
      body: sedResponse,
    );
  }

  if (paramsList.keys.contains('search')) {
    final searchProv = await prov.searchForPat(
      search: paramsList['search']!.first,
      searchIn: paramsList['type'],
    );
    return Response.json(
      statusCode: int.parse(searchProv['status_code'] as String),
      body: searchProv,
    );
  }

  final sedResponse = await prov.getUserByType(
    type: paramsList['type']!,
  );

  return Response.json(
    statusCode: int.parse(sedResponse['status_code'] as String),
    body: sedResponse,
  );
}

Future<Response> _post(RequestContext context) async {
  final prov = context.read<UserProviderImpl>();
  final bodyData = await context.request.json() as Map<String, dynamic>;
  try {} catch (e) {
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
  final sedResponse = await prov.addUser(
    userBody: bodyData,
  );
  return Response.json(
    statusCode: int.parse(sedResponse['status_code'] as String),
    body: sedResponse,
  );
}

Future<Response> _delete(RequestContext context) async {
  final prov = context.read<UserProviderImpl>();
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
  final sedResponse = await prov.deleteUsers(ids: ids);
  return Response.json(
    statusCode: int.parse(sedResponse['status_code'] as String),
    body: sedResponse,
  );
}
