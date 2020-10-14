import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'pb_log.dart';
import 'pb_error.dart';
import 'package:dio/dio.dart';

class HTTPAgent {
  static const METHOD_GET = 'GET';
  static const METHOD_POST = 'POST';
  static const METHOD_PUT = 'PUT';
  static const METHOD_DELETE = 'DELETE';
  static const int _defaultRetryCount = 3;

  static final HTTPAgent _instance = HTTPAgent._internal();
  factory HTTPAgent() => _instance;
  Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Credentials": "true",
    "Access-Control-Allow-Headers": "authorization",
    "Access-Control-Allow-Methods": "OPTIONS,HEAD,GET,PUT,POST,DELETE,PATCH"
  };
  // StreamController _status;
  Dio _dio;
  Response _response;

  // TODOS: broadcast stream
  // StreamController exceptionStreamController = StreamController.broadcast();

  HTTPAgent._internal() {
    BaseOptions options = new BaseOptions(
      // baseUrl: "",
      // connectTimeout: 5000, //5s
      // receiveTimeout: 3000,
      contentType: Headers.formUrlEncodedContentType,
    );
    _dio = Dio(options);
  }

  Future<List<dynamic>> request(String url,
      {String type = METHOD_GET,
      Map payload,
      headers,
      retryCount = _defaultRetryCount}) async {
    dynamic resultPayload;
    Map<String, dynamic> meta;
    int originCount = retryCount;

    while (retryCount-- > 0) {
      if (retryCount < originCount - 1) {
        print('Agent retry $retryCount $url');
      }
      // if (!isInternetAvailable) break;
      _useHeaders(headers).entries.toList().forEach((hds) {
        // xhr.headers.set(hds.key, hds.value);
        print(_dio.options.headers);
        print(hds);
        _dio.options.headers = {
          ..._dio.options.headers,
          hds.key: hds.value,
        };
      });

      // HttpClient client = new HttpClient();
      // HttpClientRequest xhr;
      Uri uri = Uri.parse(url);
      try {
        if (type == METHOD_GET) {
          // xhr = await client.getUrl(uri);
          _response = await _dio.getUri(uri);
        }
        if (type == METHOD_POST) {
          // xhr = await client.postUrl(uri);

          // FormData formData = FormData.fromMap(payload);
          _response = await _dio.postUri(uri, data: json.encode(payload));
        }
        if (type == METHOD_PUT) {
          // xhr = await client.putUrl(uri);
          // FormData formData = FormData.fromMap(payload);
          _response = await _dio.putUri(uri, data: json.encode(payload));
        }
        if (type == METHOD_DELETE) {
          // xhr = await client.deleteUrl(uri);
          _response = await _dio.deleteUri(uri);
        }
      } catch (e) {
        if (e is SocketException) {
          sleep(Duration(seconds: 1));
          continue;
        }
      }

      //  HttpClientResponse response = await xhr.close();
      //   String reply = await response.transform(utf8.decoder).join();

      // PBLog.verbose("Response: ${reply}");

      if (_response == null || _response?.statusCode != 200) {
        // sleep(Duration(seconds: 1));
        continue;
      }
      // client.close();
      Map<String, dynamic> data = _response.data;
      PBLog.verbose("Response data: ${data}");

      resultPayload = data["payload"];
      meta = data["meta"];
      //PBLog.warning('$meta');
      //PBLog.warning('$resultPayload');
      Map<String, dynamic> error = (meta != null) ? meta["error"] : null;
      var seconds = 1;
      int code = (error != null) ? error["code"] : null;

      if (code == 63) {
        // request limit reached
        seconds += Random().nextInt(9); // 1 ~ 10
        sleep(Duration(seconds: seconds));
        continue;
      }

      // int totalCount = meta["totalCount"];
      // int results = meta["results"];
      // if (results == null || totalCount == null) {
      //   retryCount -= 1;
      //   sleep(Duration(seconds: 1));
      //   continue;
      // }

      if (resultPayload == null) {
        sleep(Duration(seconds: seconds));
        continue;
      } else {
        break;
      }
    }

    if (resultPayload == null) {
      _handleError(meta != null ? meta['error'] : 'API SERVER ERROR');
    }
    // [payload, meta]
    return [resultPayload ?? {} as dynamic, meta ?? {} as dynamic];
  }

  _handleError(String error) {
    // TODOS:
    // exceptionStreamController.sink.add(error);
    // _status.sink.add([
    //   PBError.api, error
    //   // !isInternetAvailable ? 'Please check internet connection status.' : error
    // ]);
  }

  Map<String, String> _useHeaders(Map<String, String> headers) =>
      {...?_defaultHeaders, ...?headers};

  void setHeaders(Map<String, String> headers) {
    _defaultHeaders = {..._defaultHeaders, ...headers};
  }
}
