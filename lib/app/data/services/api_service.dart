import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';

import 'package:logger/logger.dart';
import 'api_endpoints.dart';
import 'token_service.dart';

class ApiService extends GetConnect {
  static final ApiService _instance = ApiService._internal();
  final TokenService tokenService = TokenService();

  @override
  String get baseUrl => ApiEndpoints.baseUrl;

  ApiService._internal() {
    httpClient.baseUrl = baseUrl;
    httpClient.timeout = const Duration(seconds: 60);
  }

  factory ApiService() {
    return _instance;
  }

  final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 0,
      lineLength: 300,
      colors: true,
      printEmojis: false,
    ),
  );

  Future<Map<String, String>> _getDefaultHeaders() async {
    String? token = await tokenService.token;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Internal method to handle all HTTP requests
  Future<Response> _makeRequest({
    required String method,
    required String url,
    Map<String, dynamic>? query,
    dynamic body,
    Map<String, String>? headers,
    List<MultipartFile>? files,
  })
  async {
    final combinedHeaders = {
      ...await _getDefaultHeaders(),
      ...?headers
    };

    logger.i('Request: $method $baseUrl$url \n body: $body');

    try {
      Response response;
      switch (method) {
        case 'GET':
          response = await get(url, query: query, headers: combinedHeaders);
          break;
        case 'POST':
          if (files != null && files.isNotEmpty) {
            final form = FormData(query ?? {});
            form.files.addAll(files.map((file) => MapEntry(file.filename, file)));
            response = await post(url, form, headers: combinedHeaders);
          } else {

            response = await post(url, body, query: query, headers: combinedHeaders);

          }
          break;
        case 'DELETE':
          response = await delete(url, query: query, headers: combinedHeaders);
          break;
        default:
          throw UnsupportedError('Unsupported HTTP method: $method');
      }

      logger.t('Response: ${response.statusCode} ${response.bodyString}');

      if (response.body != null) {
        if (response.statusCode == 200) {
          return response;
        } else if (response.statusCode! >= 500 && response.statusCode! < 600) {
          throw ('Server error: Please try again later.');
        } else {
          final body = response.body;
          if (body is Map && body.containsKey('message')) {
            throw (body['message']);
          } else if (body is String) {
            throw (body);
          } else {
            throw ('Unknown error occurred');
          }
        }
      } else {
        throw const SocketException('You have no Internet Connection');
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException) {
        throw ('Network error: Please check your internet connection.');
      } else if (e is FormatException) {
        throw ('Invalid response format: Please contact support.');
      } else if (e.toString().contains('Server error: Please try again later.')) {
        throw ('Server error: Please try again later.');
      } else {
        throw (e.toString());
      }
    }
  }

  Future<Response> getApi({
    required String url,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    return await _makeRequest(method: 'GET', url: url, query: query, headers: headers);
  }

  Future<Response> postApi({
    required String url,
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    List<MultipartFile>? files,
  }) async {
    return await _makeRequest(method: 'POST', url: url, query: query, body: body, headers: headers, files: files);
  }

  Future<Response> deleteApi({
    required String url,
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    return await _makeRequest(method: 'DELETE', url: url, query: query, body: body, headers: headers);
  }

  Future<Response> uploadSingleImage({
    required String url,
    required String imageFieldKey,
    required File imageFile,
    Map<String, dynamic>? fields,
    Map<String, String>? headers,
  }) async {
    final combinedHeaders = {
      ...await _getDefaultHeaders()..remove('Content-Type'),
      ...?headers,
    };

    final multipartFile = MultipartFile(
      imageFile,
      filename: imageFile.path.split('/').last,
    );

    final formData = FormData(
      (fields ?? {}).map((key, value) => MapEntry(key, value.toString())),
    );

    formData.files.add(MapEntry(imageFieldKey, multipartFile));

    logger.i('Uploading image to $url');

    final response = await post(url, formData, headers: combinedHeaders); // This is GetConnect.post

    logResponse(url, response);

    return response;
  }


  void logRequest(String url, Map<String, dynamic>? q, {String? additional}) {
    logger.i(
        '$url \n ${jsonEncode(q)}${additional == null ? '' : '\n$additional'}');
  }
  void logResponse(String url, Response response) {
    final bodyString = jsonEncode(response.body); // convert Map to String

    String res = '';
    if (bodyString.length > 800) {
      final parts = _splitByLength(bodyString, 800);
      for (var e in parts) {
        res += '$e\n';
      }
    } else {
      res = bodyString;
    }

    logger.v('${response.statusCode} \n $res');
  }

  List<String> _splitByLength(String str, int chunkSize) {
    final List<String> chunks = [];
    for (int i = 0; i < str.length; i += chunkSize) {
      chunks.add(str.substring(i, i + chunkSize > str.length ? str.length : i + chunkSize));
    }
    return chunks;
  }

  // REFACTORED: This method now directly creates and sends FormData
  Future<Response> uploadFiles({
    required String url,
    required List<File> files,
    required String fileKey, // This is crucial for the backend field name
    Map<String, dynamic>? fields,
    Map<String, String>? headers,
  }) async {
    // Get default headers, but remove 'Content-Type' as it's handled by FormData for multipart
    final combinedHeaders = {
      ...await _getDefaultHeaders()..remove('Content-Type'),
      ...?headers,
    };

    // Create FormData with fields
    final formData = FormData(
      (fields ?? {}).map((key, value) => MapEntry(key, value.toString())),
    );

    // Add files to FormData using the specified fileKey for each file
    for (var file in files) {
      formData.files.add(MapEntry(
        '$fileKey[]', // <-- Notice the brackets here
        MultipartFile(file, filename: file.path.split('/').last),
      ));
    }


    logger.i('Uploading files request: POST $baseUrl$url');
    logger.i('  Fields: ${jsonEncode(fields)}');
    logger.i('  Files ($fileKey): ${files.map((f) => f.path.split('/').last).join(', ')}');

    // Make the POST request directly using GetConnect's post method
    final response = await post(url, formData, headers: combinedHeaders);

    logResponse(url, response);

    return response;
  }
}