import 'package:flutter/foundation.dart';

class ApiConstants {
  ApiConstants._();

  // ---------------------------------------------------------------------------
  // Development / Production URLs
  // ---------------------------------------------------------------------------

  static const String _desktop = "http://127.0.0.1:8000";
  static const String _android = "http://10.0.2.2:8000";
  static const String _production = "https://api.aizillon.ai";

  static String get baseUrl {
    if (kReleaseMode) {
      return _production;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return _android;
    }

    return _desktop;
  }

  // ---------------------------------------------------------------------------
  // HTTP Configuration
  // ---------------------------------------------------------------------------

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);

  // ---------------------------------------------------------------------------
  // Core API Endpoints
  // ---------------------------------------------------------------------------

  static const String health = "/health";
  static const String execute = "/execute";
  static const String chart = "/chart";
  static const String insight = "/insight";
  static const String report = "/report";
  static const String mcpServers = "/mcp-servers";

  // ---------------------------------------------------------------------------
  // RAG Endpoints
  // ---------------------------------------------------------------------------

  /// Create / list RAG spaces
  ///
  /// POST /rag/spaces
  /// GET  /rag/spaces
  static const String ragSpaces = "/rag/spaces";

  /// Get / delete a specific RAG space
  ///
  /// GET    /rag/spaces/{spaceId}
  /// DELETE /rag/spaces/{spaceId}
  static String ragSpace(String spaceId) {
    return "/rag/spaces/$spaceId";
  }

  /// Upload / list documents for a RAG space
  ///
  /// POST /rag/spaces/{spaceId}/documents
  /// GET  /rag/spaces/{spaceId}/documents
  static String ragSpaceDocuments(String spaceId) {
    return "/rag/spaces/$spaceId/documents";
  }

  /// Retrieve relevant chunks from a RAG space
  ///
  /// POST /rag/spaces/{spaceId}/retrieve
  static String ragSpaceRetrieve(String spaceId) {
    return "/rag/spaces/$spaceId/retrieve";
  }
}
