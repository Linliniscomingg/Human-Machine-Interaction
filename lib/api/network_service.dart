import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../data/services/Preferences.dart';


class NetworkService {
  Dio? _dio;
  final JsonEncoder _encoder = const JsonEncoder();
  static final NetworkService _instance = NetworkService.internal();

  NetworkService.internal();

  static NetworkService get instance => _instance;

  Future<void> initClient({String? token}) async {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.40.222:3000',
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );
    _dio?.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Get token from secure storage or preferences
        final token = Preferences.getJwtSecret();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
// A place for interceptors. For example, for authentication and logging
  }

  Future<dynamic> get(
      String url, {
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      final response = await _dio?.get(url, queryParameters: queryParameters);
      return response?.data;
    } on DioException catch (e) {
      final data = Map<String, dynamic>.from(e.response?.data);
      throw Exception(data['message'] ?? "Error while fetching data");
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> download(String url, String path) async {
    return _dio?.download(url, path).then((Response response) {
      if (response.statusCode! < 200 || response.statusCode! > 400) {
        throw Exception("Error while fetching data");
      }
      return response.data;
    }).onError((error, stackTrace) {
      throw Exception(error);
    });
  }

  Future<dynamic> delete(String url) async {
    return _dio?.delete(url).then((Response response) {
      if (response.statusCode! < 200 || response.statusCode! > 400) {
        throw Exception("Error while fetching data");
      }
      return response.data;
    }).onError((DioException error, stackTrace) {
      debugPrint(error.response as String?);
    });
  }

  Future<dynamic> post(String url, {body, encoding}) async {
    try {
      final response = await _dio?.post(url, data: _encoder.convert(body));
      return response?.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postFormData(String url, {required FormData data}) async {
    try {
      final response = await _dio?.post(url, data: data);
      return response?.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> patch(String url, {body, encoding}) async {
    try {
      final response = await _dio?.patch(url, data: _encoder.convert(body));
      return response?.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> put(String url, {body, encoding}) async {
    try {
      final response = await _dio?.put(url, data: _encoder.convert(body));
      return response?.data;
    } on DioException catch (e) {
      throw e.toString();
    } catch (e) {
      rethrow;
    }
  }
}