import '../models/rag_document.dart';
import '../models/rag_retrieval.dart';
import '../models/rag_space.dart';

class RagState {
  final bool isLoadingSpaces;
  final bool isLoadingDocuments;
  final bool isRetrieving;
  final bool isUploadingDocument;
  final bool isDeletingDocument;

  final List<RagSpace> spaces;
  final RagSpace? selectedSpace;

  final List<RagDocument> documents;

  final RagDocument? selectedDocument;

  final RagRetrievalResponse? retrievalResponse;

  final String? errorMessage;

  const RagState({
    this.isLoadingSpaces = false,
    this.isLoadingDocuments = false,
    this.isRetrieving = false,
    this.isUploadingDocument = false,
    this.isDeletingDocument = false,
    this.spaces = const [],
    this.selectedSpace,
    this.documents = const [],
    this.selectedDocument,
    this.retrievalResponse,
    this.errorMessage,
  });

  RagState copyWith({
    bool? isLoadingSpaces,
    bool? isLoadingDocuments,
    bool? isRetrieving,
    bool? isUploadingDocument,
    bool? isDeletingDocument,
    List<RagSpace>? spaces,
    RagSpace? selectedSpace,
    List<RagDocument>? documents,
    RagDocument? selectedDocument,
    RagRetrievalResponse? retrievalResponse,
    String? errorMessage,
    bool clearSelectedSpace = false,
    bool clearSelectedDocument = false,
    bool clearRetrievalResponse = false,
    bool clearError = false,
  }) {
    return RagState(
      isLoadingSpaces: isLoadingSpaces ?? this.isLoadingSpaces,
      isLoadingDocuments: isLoadingDocuments ?? this.isLoadingDocuments,
      isRetrieving: isRetrieving ?? this.isRetrieving,
      isUploadingDocument: isUploadingDocument ?? this.isUploadingDocument,
      isDeletingDocument: isDeletingDocument ?? this.isDeletingDocument,

      spaces: spaces ?? this.spaces,

      selectedSpace:
          clearSelectedSpace ? null : selectedSpace ?? this.selectedSpace,

      documents: documents ?? this.documents,

      selectedDocument:
          clearSelectedDocument
              ? null
              : selectedDocument ?? this.selectedDocument,

      retrievalResponse:
          clearRetrievalResponse
              ? null
              : retrievalResponse ?? this.retrievalResponse,

      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
