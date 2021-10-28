import 'dart:convert';

import 'package:http/http.dart';
import 'package:incidencias/app/core/utils/helpers/http/http.dart';

dynamic _parseBody(dynamic body) {
  try {
    return jsonEncode(body);
  } catch (_) {
    return body;
  }
}

Future<Response> sendRequest(
    {required Uri url,
    required HttpMethod method,
    required Map<String, String> headers,
    required dynamic body,
    required Duration timeOut}) {
  var finalHeader = {...headers};
  if (method != HttpMethod.get) {
    final contentType = headers['Content-Type'];
    if (contentType == null) {
    } else if (contentType.contains('application/json')) {
      finalHeader['Content-Type'] = 'application/json;charset=UTF-8';
      body = _parseBody(body);
    }
  }
  final client = Client();
  switch (method) {
    case HttpMethod.get:
      return client.get(url, headers: finalHeader).timeout(timeOut);
    case HttpMethod.post:
      return client
          .post(url, headers: finalHeader, body: body)
          .timeout(timeOut);
    case HttpMethod.put:
      return client.put(url, headers: finalHeader, body: body).timeout(timeOut);
    case HttpMethod.patch:
      return client
          .patch(url, headers: finalHeader, body: body)
          .timeout(timeOut);
    case HttpMethod.delete:
      return client
          .delete(url, headers: finalHeader, body: body)
          .timeout(timeOut);
  }
}
