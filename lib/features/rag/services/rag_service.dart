import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_constants.dart';

class RagService {
  RagService._();

  static final RagService instance = RagService._();

  // ---------------------------------------------------------------------------
  // Spaces
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getSpaces() async {
    try {
      final response = await ApiClient.dio.get(ApiConstants.ragSpaces);

      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception(_extractError(e, 'Failed to load RAG spaces'));
    }
  }

  Future<dynamic> getSpace(String spaceId) async {
    try {
      final response = await ApiClient.dio.get(ApiConstants.ragSpace(spaceId));

      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractError(e, 'Failed to load RAG space'));
    }
  }

  Future<dynamic> createSpace({
    required String name,
    required String description,
    required String embeddingModel,
    required String vectorStore,
    required int chunkSize,
    required int chunkOverlap,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        ApiConstants.ragSpaces,
        data: {
          'name': name,
          'description': description,
          'embedding_provider': 'ollama',
          'embedding_model': embeddingModel,
          'vector_store': vectorStore.toLowerCase(),
          'chunk_size': chunkSize,
          'chunk_overlap': chunkOverlap,
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractError(e, 'Failed to create RAG space'));
    }
  }

  Future<void> deleteSpace(String spaceId) async {
    try {
      await ApiClient.dio.delete(ApiConstants.ragSpace(spaceId));
    } on DioException catch (e) {
      throw Exception(_extractError(e, 'Failed to delete RAG space'));
    }
  }

  // ---------------------------------------------------------------------------
  // Documents
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getDocuments(String spaceId) async {
    try {
      final response = await ApiClient.dio.get(
        ApiConstants.ragSpaceDocuments(spaceId),
      );

      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception(_extractError(e, 'Failed to load RAG documents'));
    }
  }

  Future<dynamic> getDocument({
    required String spaceId,
    required String documentId,
  }) async {
    try {
      final response = await ApiClient.dio.get(
        '${ApiConstants.ragSpaceDocuments(spaceId)}/$documentId',
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractError(e, 'Failed to load RAG document'));
    }
  }

  /// Upload a document using in-memory bytes.
  ///
  /// This implementation is Flutter Web compatible.
  /// Do NOT use MultipartFile.fromFile() here because dart:io
  /// is not available when running Flutter Web.
  Future<dynamic> uploadDocument({
    required String spaceId,
    required List<int> fileBytes,
    required String fileName,
  }) async {
    try {
      if (fileBytes.isEmpty) {
        throw Exception('Selected file is empty.');
      }

      final multipartFile = MultipartFile.fromBytes(
        fileBytes,
        filename: fileName,
      );

      final formData = FormData.fromMap({'file': multipartFile});

      final response = await ApiClient.dio.post(
        ApiConstants.ragSpaceDocuments(spaceId),
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractError(e, 'Failed to upload RAG document'));
    }
  }

  Future<dynamic> deleteDocument({
    required String spaceId,
    required String documentId,
  }) async {
    try {
      final response = await ApiClient.dio.delete(
        '${ApiConstants.ragSpaceDocuments(spaceId)}/$documentId',
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractError(e, 'Failed to delete RAG document'));
    }
  }

  // ---------------------------------------------------------------------------
  // Retrieval
  // ---------------------------------------------------------------------------

  Future<dynamic> retrieve({
    required String spaceId,
    required String query,
    int topK = 5,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        ApiConstants.ragSpaceRetrieve(spaceId),
        data: {'query': query, 'top_k': topK},
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractError(e, 'RAG retrieval failed'));
    }
  }

  // ---------------------------------------------------------------------------
  // Error handling
  // ---------------------------------------------------------------------------

  String _extractError(DioException error, String fallback) {
    final data = error.response?.data;

    if (data is Map) {
      final detail = data['detail'];

      if (detail != null) {
        return detail.toString();
      }

      final message = data['message'];

      if (message != null) {
        return message.toString();
      }

      final errorMessage = data['error'];

      if (errorMessage != null) {
        return errorMessage.toString();
      }
    }

    return error.message ?? fallback;
  }
}
