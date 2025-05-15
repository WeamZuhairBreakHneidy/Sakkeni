import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';

import 'package:logger/logger.dart';
import 'api_endpoints.dart';
import 'token_service.dart';

class ApiService extends GetConnect {
  // Singleton pattern: Ensure only one instance of ApiService exists
  static final ApiService _instance = ApiService._internal();
  final TokenService tokenService = TokenService();

  @override
  String get baseUrl => ApiEndpoints.baseUrl;

  // Internal constructor for singleton pattern
  ApiService._internal() {
    httpClient.baseUrl = baseUrl;
    httpClient.timeout = const Duration(seconds: 60);
  }

  // Factory constructor for singleton pattern
  factory ApiService() {
    return _instance;
  }

  // Logger for debugging and tracking requests and responses
  final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 0,
      lineLength: 300,
      colors: true,
      printEmojis: false,
    ),
  );

  // Method to get default headers asynchronously
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
      ...await _getDefaultHeaders(), // Asynchronously get the default headers
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

  // Public method for GET requests
  Future<Response> getApi({
    required String url,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    return await _makeRequest(method: 'GET', url: url, query: query, headers: headers);
  }

  // Public method for POST requests
  Future<Response> postApi({
    required String url,
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    List<MultipartFile>? files,
  }) async {
    return await _makeRequest(method: 'POST', url: url, query: query, body: body, headers: headers, files: files);
  }

  // Public method for DELETE requests
  Future<Response> deleteApi({
    required String url,
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    return await _makeRequest(method: 'DELETE', url: url, query: query, body: body, headers: headers);
  }

  // Public method for uploading files
  Future<Response> uploadFiles({
    required String url,
    required List<File> files,
    required String fileKey,
    Map<String, dynamic>? fields,
    Map<String, String>? headers,
  }) async {
    final fileUploads = files.map((file) {
      return MultipartFile(file, filename: file.path.split('/').last);
    }).toList();

    return await postApi(url: url, query: fields, headers: headers, files: fileUploads);
  }
}
