import 'package:dio/dio.dart';
import 'package:aizillon/core/api/api_client.dart';
import 'package:aizillon/core/api/api_constants.dart';

class HealthApi {
  Future<Map<String, dynamic>> health() async {
    final Response response = await ApiClient.dio.get(ApiConstants.health);

    return Map<String, dynamic>.from(response.data);
  }
}
