import 'package:dio/dio.dart';

import '../../auth/auth_storage.dart';
import 'api_constants.dart';

class ApiClient {
  ApiClient._();

  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (
              RequestOptions options,
              RequestInterceptorHandler handler,
            ) async {
              try {
                final token = await AuthStorage.getAccessToken();

                if (token != null && token.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $token';
                }
              } catch (_) {
                // Do not prevent the request from being sent
                // if secure storage cannot be read.
              }

              handler.next(options);
            },

            onError: (
              DioException error,
              ErrorInterceptorHandler handler,
            ) async {
              if (error.response?.statusCode == 401) {
                await AuthStorage.clear();
              }

              handler.next(error);
            },
          ),
        )
        ..interceptors.add(
          LogInterceptor(request: true, requestBody: true, responseBody: true),
        );
}
