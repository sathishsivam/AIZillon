class RagRetrievedDocument {
  final String content;
  final Map<String, dynamic> metadata;

  const RagRetrievedDocument({required this.content, required this.metadata});

  factory RagRetrievedDocument.fromJson(Map<String, dynamic> json) {
    return RagRetrievedDocument(
      content: json['content']?.toString() ?? '',
      metadata:
          json['metadata'] is Map
              ? Map<String, dynamic>.from(json['metadata'])
              : <String, dynamic>{},
    );
  }

  String get fileName =>
      metadata['file_name']?.toString() ?? 'Unknown document';

  String get documentId => metadata['document_id']?.toString() ?? '';

  int? get pageNumber => (metadata['page_number'] as num?)?.toInt();

  int? get chunkIndex => (metadata['chunk_index'] as num?)?.toInt();
}

class RagRetrievalSource {
  final String fileName;
  final String documentId;
  final int? pageNumber;
  final int? chunkIndex;

  const RagRetrievalSource({
    required this.fileName,
    required this.documentId,
    this.pageNumber,
    this.chunkIndex,
  });

  factory RagRetrievalSource.fromJson(Map<String, dynamic> json) {
    return RagRetrievalSource(
      fileName: json['file_name']?.toString() ?? '',
      documentId: json['document_id']?.toString() ?? '',
      pageNumber: (json['page_number'] as num?)?.toInt(),
      chunkIndex: (json['chunk_index'] as num?)?.toInt(),
    );
  }
}

class RagRetrievalResponse {
  final String query;
  final String status;
  final List<RagRetrievedDocument> documents;
  final List<RagRetrievalSource> sources;
  final String context;

  const RagRetrievalResponse({
    required this.query,
    required this.status,
    required this.documents,
    required this.sources,
    required this.context,
  });

  factory RagRetrievalResponse.fromJson(Map<String, dynamic> json) {
    final documentsJson = json['documents'] as List? ?? [];
    final sourcesJson = json['sources'] as List? ?? [];

    return RagRetrievalResponse(
      query: json['query']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      documents:
          documentsJson
              .whereType<Map>()
              .map(
                (item) => RagRetrievedDocument.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList(),
      sources:
          sourcesJson
              .whereType<Map>()
              .map(
                (item) => RagRetrievalSource.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList(),
      context: json['context']?.toString() ?? '',
    );
  }
}
