class RagSpace {
  final String id;
  final String name;
  final String description;

  final String embeddingProvider;
  final String embeddingModel;

  final String vectorStore;

  final int chunkSize;
  final int chunkOverlap;

  final int documentCount;
  final int chunkCount;

  final String status;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RagSpace({
    required this.id,
    required this.name,
    required this.description,
    required this.embeddingProvider,
    required this.embeddingModel,
    required this.vectorStore,
    required this.chunkSize,
    required this.chunkOverlap,
    required this.documentCount,
    required this.chunkCount,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory RagSpace.fromJson(Map<String, dynamic> json) {
    return RagSpace(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      embeddingProvider: json['embedding_provider']?.toString() ?? 'ollama',
      embeddingModel: json['embedding_model']?.toString() ?? 'nomic-embed-text',
      vectorStore: json['vector_store']?.toString() ?? 'faiss',
      chunkSize: (json['chunk_size'] as num?)?.toInt() ?? 1000,
      chunkOverlap: (json['chunk_overlap'] as num?)?.toInt() ?? 150,
      documentCount: (json['document_count'] as num?)?.toInt() ?? 0,
      chunkCount: (json['chunk_count'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? 'DRAFT',
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'embedding_provider': embeddingProvider,
      'embedding_model': embeddingModel,
      'vector_store': vectorStore,
      'chunk_size': chunkSize,
      'chunk_overlap': chunkOverlap,
      'document_count': documentCount,
      'chunk_count': chunkCount,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
  }
}
