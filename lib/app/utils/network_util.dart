import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:in_motion/app/constants/app_constants.dart';

class NetworkUtil {
  late Dio _dio;
  final String baseUrl = AppConstants.baseUrl;

  static final NetworkUtil _instance = NetworkUtil._internal();

  factory NetworkUtil() => _instance;

  NetworkUtil._internal() {
    BaseOptions options = BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {},
        contentType: "application/json",
        responseType: ResponseType.json);
    _dio = Dio(options);

    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      return handler.next(options);
    }, onResponse: (response, handler) {
      return handler.next(response);
    }, onError: (DioException e, handler) {
      if (kDebugMode) {
        print("app error data $e");
      }
      if (e.response!.data['message'] is Map) {
        var data = e.response!.data['message'];
        if (data.containsKey("email") && data.containsKey("phone")) {
          throw ErrorEntity(
              message: "No Data found",
              data: {"email": data['email'], "phone": data['phone']});
        } else {
          ErrorEntity eInfo = _handleError(e);
          throw eInfo;
        }
      } else {
        ErrorEntity eInfo = _handleError(e);
        throw eInfo;
      }
    }));
  }

  Future get(
      {required String path,
      Object? data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken}) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = {
      'X-RapidAPI-Key': AppConstants.rapidAPIKey,
      'X-RapidAPI-Host': AppConstants.rapidAPIHost,
    };

    var response = await _dio.get(path,
        data: data,
        queryParameters: queryParameters,
        options: requestOptions,
        cancelToken: cancelToken);

    return response.data;
  }

  ErrorEntity _handleError(error) {
    String errorMessage = 'Something went wrong';

    if (error is DioException) {
      if (error.response != null) {
        errorMessage = error.response?.data['message'] ?? errorMessage;
      } else {
        switch (error.type) {
          case DioExceptionType.connectionTimeout:
            errorMessage = "Connection timed out";
            break;

          case DioExceptionType.sendTimeout:
            errorMessage = "Send timed out";
            break;

          case DioExceptionType.receiveTimeout:
            errorMessage = "Receive timed out";
            break;

          case DioExceptionType.badCertificate:
            errorMessage = "Bad SSL certificates";
            break;

          case DioExceptionType.badResponse:
            switch (error.response!.statusCode) {
              case 400:
                errorMessage = "Bad request";
                break;
              case 401:
                errorMessage = "Permission denied";
                break;
              case 500:
                errorMessage = "Server internal error";
                break;
            }
            errorMessage = "Server bad response";
            break;

          case DioExceptionType.cancel:
            errorMessage = "Server canceled it";
            break;

          case DioExceptionType.connectionError:
            errorMessage = "Connection error";
            break;

          case DioExceptionType.unknown:
            errorMessage = "Unknown error";
            break;
        }
      }
      return ErrorEntity(
        message: errorMessage,
      );
    } else {
      return ErrorEntity(message: errorMessage);
    }
  }
}

class ErrorEntity implements Exception {
  String message = "";
  dynamic data;

  ErrorEntity({required this.message, this.data});

  @override
  String toString() {
    if (message == "") return "Exception";

    return message;
  }
}
