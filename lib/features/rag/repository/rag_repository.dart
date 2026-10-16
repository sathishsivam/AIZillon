import 'package:flutter/foundation.dart';

import '../models/rag_document.dart';
import '../models/rag_retrieval.dart';
import '../models/rag_space.dart';
import '../services/rag_service.dart';

class RagRepository {
  final RagService service;

  RagRepository({RagService? service})
    : service = service ?? RagService.instance;

  // ---------------------------------------------------------------------------
  // Spaces
  // ---------------------------------------------------------------------------

  Future<List<RagSpace>> getSpaces() async {
    final response = await service.getSpaces();

    return response
        .whereType<Map>()
        .map((item) => RagSpace.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<RagSpace> getSpace(String spaceId) async {
    final response = await service.getSpace(spaceId);

    return RagSpace.fromJson(Map<String, dynamic>.from(response));
  }

  Future<RagSpace> createSpace({
    required String name,
    required String description,
    required String embeddingModel,
    required String vectorStore,
    required int chunkSize,
    required int chunkOverlap,
  }) async {
    debugPrint('RAG: Creating space "$name"');

    final response = await service.createSpace(
      name: name,
      description: description,
      embeddingModel: embeddingModel,
      vectorStore: vectorStore,
      chunkSize: chunkSize,
      chunkOverlap: chunkOverlap,
    );

    debugPrint('RAG: Create space response: $response');

    return RagSpace.fromJson(Map<String, dynamic>.from(response));
  }

  Future<void> deleteSpace(String spaceId) async {
    debugPrint('RAG: Deleting space $spaceId');

    await service.deleteSpace(spaceId);

    debugPrint('RAG: Space $spaceId deleted');
  }

  // ---------------------------------------------------------------------------
  // Documents
  // ---------------------------------------------------------------------------

  Future<List<RagDocument>> getDocuments(String spaceId) async {
    debugPrint('RAG: Loading documents for space: $spaceId');

    final response = await service.getDocuments(spaceId);

    debugPrint('RAG: Document API response: $response');

    final documents =
        response
            .whereType<Map>()
            .map(
              (item) => RagDocument.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();

    debugPrint('RAG: Parsed ${documents.length} documents');

    for (final document in documents) {
      debugPrint(
        'RAG: ${document.fileName} '
        'status=${document.status} '
        'pages=${document.pageCount} '
        'chunks=${document.chunkCount}',
      );
    }

    return documents;
  }

  Future<RagDocument> getDocument({
    required String spaceId,
    required String documentId,
  }) async {
    debugPrint('RAG: Loading document $documentId');

    final response = await service.getDocument(
      spaceId: spaceId,
      documentId: documentId,
    );

    return RagDocument.fromJson(Map<String, dynamic>.from(response));
  }

  // ---------------------------------------------------------------------------
  // Upload Document
  // ---------------------------------------------------------------------------

  /// Upload a document using its in-memory bytes.
  ///
  /// This is compatible with Flutter Web.
  ///
  /// The UI obtains the bytes using:
  ///
  /// FilePicker.pickFiles(
  ///   withData: true,
  /// )
  ///
  /// and passes those bytes through this method.
  Future<RagDocument> uploadDocument({
    required String spaceId,
    required List<int> fileBytes,
    required String fileName,
  }) async {
    debugPrint(
      'RAG: Uploading $fileName '
      'to space $spaceId',
    );

    debugPrint('RAG: Upload size: ${fileBytes.length} bytes');

    if (fileBytes.isEmpty) {
      throw Exception('Selected file is empty.');
    }

    if (fileName.trim().isEmpty) {
      throw Exception('Selected file has no file name.');
    }

    final response = await service.uploadDocument(
      spaceId: spaceId,
      fileBytes: fileBytes,
      fileName: fileName,
    );

    debugPrint('RAG: Document upload response: $response');

    return RagDocument.fromJson(Map<String, dynamic>.from(response));
  }

  Future<void> deleteDocument({
    required String spaceId,
    required String documentId,
  }) async {
    debugPrint('RAG: Deleting document $documentId');

    await service.deleteDocument(spaceId: spaceId, documentId: documentId);

    debugPrint('RAG: Document $documentId deleted');
  }

  // ---------------------------------------------------------------------------
  // Retrieval
  // ---------------------------------------------------------------------------

  Future<RagRetrievalResponse> retrieve({
    required String spaceId,
    required String query,
    int topK = 5,
  }) async {
    debugPrint(
      'RAG: Retrieving documents '
      'for space: $spaceId',
    );

    debugPrint('RAG: Query: $query');

    final response = await service.retrieve(
      spaceId: spaceId,
      query: query,
      topK: topK,
    );

    debugPrint('RAG: Retrieval response received');

    return RagRetrievalResponse.fromJson(Map<String, dynamic>.from(response));
  }
}
