class RagDocument {
  final String id;
  final String spaceId;

  final String fileName;
  final String fileType;

  final int fileSize;
  final int pageCount;
  final int chunkCount;

  final String status;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RagDocument({
    required this.id,
    required this.spaceId,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.pageCount,
    required this.chunkCount,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory RagDocument.fromJson(Map<String, dynamic> json) {
    return RagDocument(
      id: json['id']?.toString() ?? '',
      spaceId: json['space_id']?.toString() ?? '',
      fileName: json['file_name']?.toString() ?? '',
      fileType: json['file_type']?.toString() ?? '',
      fileSize: (json['file_size'] as num?)?.toInt() ?? 0,
      pageCount: (json['page_count'] as num?)?.toInt() ?? 0,
      chunkCount: (json['chunk_count'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? 'PROCESSING',
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'space_id': spaceId,
      'file_name': fileName,
      'file_type': fileType,
      'file_size': fileSize,
      'page_count': pageCount,
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
