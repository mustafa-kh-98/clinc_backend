import 'package:mongo_dart/mongo_dart.dart';

class Common {
  static Map<String, dynamic> sendSuccessResponse({
    required String statusCode,
    required String message,
    required dynamic data,
  }) {
    return {
      'status_code': statusCode,
      'message': message,
      'data': data,
    };
  }

  static Map<String, dynamic> sendErrorResponse({
    required String statusCode,
    required String message,
    required List<String> errorMessage,
  }) {
    return {
      'status_code': statusCode,
      'message': message,
      'error': errorMessage,
    };
  }

  static Map<String, dynamic> removeNullFromMap(Map<String, dynamic> data) {
    data.removeWhere((key, value) => value == null);
    return data;
  }

  static updateOnlyFiledName(
    ModifierBuilder modifierBuilder,
    Map<String, dynamic> fields,
    String parentFieldName,
  ) {
    for (final entry in fields.entries) {
      final fieldName = entry.key;
      final value = entry.value;
      if (value is Map<String, dynamic>) {
        updateOnlyFiledName(
          modifierBuilder,
          value,
          '$parentFieldName.$fieldName',
        );
      } else {
        modifierBuilder = modifierBuilder
          ..set(
            '$parentFieldName.$fieldName',
            value,
          );
      }
    }
  }

  static Future<Map<String, dynamic>> paginationResponse({
    required int page,
    required int limit,
    required DbCollection col,
    required List<Map<String, Object>> query,
  }) async {
    final skipItems = (page-1) * limit;

    final countQuery = [
      ...query,
      {
        r'$count': 'count',
      },
    ];
    final paginationQuery = [
      {
        r'$sort': {
          'updated_at': -1,
        },
      },
      {
        r'$skip': skipItems,
      },
      {
        r'$limit': limit,
      }
    ];

    final totalDocs = await col
        .modernAggregate(
          countQuery,
        )
        .first;

    final docsPage = await col.modernAggregate(
      [
        ...query,
        ...paginationQuery,
      ],
    ).toList();

    return {
      'docs': docsPage,
      'page': page,
      'limit': limit,
      'total_docs': totalDocs['count'],
      'hase_next_page': page*limit<=(totalDocs['count'] as int),
      'hase_previous_page': page!=1,
    };
  }
}
