import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/rag_document.dart';
import '../repository/rag_repository.dart';
import 'rag_state.dart';

final ragRepositoryProvider = Provider<RagRepository>((ref) {
  return RagRepository();
});

final ragControllerProvider = NotifierProvider<RagController, RagState>(
  RagController.new,
);

class RagController extends Notifier<RagState> {
  late final RagRepository _repository;

  @override
  RagState build() {
    _repository = ref.read(ragRepositoryProvider);
    return const RagState();
  }

  // ---------------------------------------------------------------------------
  // Spaces
  // ---------------------------------------------------------------------------

  Future<void> loadSpaces() async {
    state = state.copyWith(isLoadingSpaces: true, clearError: true);

    try {
      final spaces = await _repository.getSpaces();

      state = state.copyWith(isLoadingSpaces: false, spaces: spaces);
    } catch (e) {
      state = state.copyWith(
        isLoadingSpaces: false,
        errorMessage: _getErrorMessage(e),
      );
    }
  }

  Future<bool> createSpace({
    required String name,
    required String description,
    required String embeddingModel,
    required String vectorStore,
    required int chunkSize,
    required int chunkOverlap,
  }) async {
    if (name.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'RAG Space name is required.');
      return false;
    }

    state = state.copyWith(isLoadingSpaces: true, clearError: true);

    try {
      debugPrint('RAG: Creating space "${name.trim()}"');

      final space = await _repository.createSpace(
        name: name.trim(),
        description: description.trim(),
        embeddingModel: embeddingModel,
        vectorStore: vectorStore,
        chunkSize: chunkSize,
        chunkOverlap: chunkOverlap,
      );

      debugPrint(
        'RAG: Space created successfully '
        '${space.id} - ${space.name}',
      );

      state = state.copyWith(
        isLoadingSpaces: false,
        spaces: [...state.spaces, space],
      );

      return true;
    } catch (e) {
      debugPrint('RAG: Create space failed: $e');

      state = state.copyWith(
        isLoadingSpaces: false,
        errorMessage: _getErrorMessage(e),
      );

      return false;
    }
  }

  Future<void> selectSpace(String spaceId) async {
    debugPrint('RAG: Selecting space $spaceId');

    state = state.copyWith(
      isLoadingDocuments: true,
      clearError: true,
      clearRetrievalResponse: true,
      clearSelectedDocument: true,
    );

    try {
      final space = await _repository.getSpace(spaceId);

      debugPrint('RAG: Space loaded: ${space.name}');

      final documents = await _repository.getDocuments(spaceId);

      debugPrint(
        'RAG: Controller received '
        '${documents.length} documents',
      );

      state = state.copyWith(
        isLoadingDocuments: false,
        selectedSpace: space,
        documents: documents,
      );

      debugPrint(
        'RAG: State updated with '
        '${state.documents.length} documents',
      );
    } catch (e) {
      debugPrint('RAG: selectSpace failed: $e');

      state = state.copyWith(
        isLoadingDocuments: false,
        errorMessage: _getErrorMessage(e),
      );
    }
  }

  Future<void> refreshSelectedSpace() async {
    final space = state.selectedSpace;

    if (space == null) {
      return;
    }

    await selectSpace(space.id);
  }

  void clearSelection() {
    state = state.copyWith(
      clearSelectedSpace: true,
      clearSelectedDocument: true,
      documents: const [],
      clearRetrievalResponse: true,
      clearError: true,
    );
  }

  // ---------------------------------------------------------------------------
  // Documents
  // ---------------------------------------------------------------------------

  /// Upload a document using in-memory bytes.
  ///
  /// This is Flutter Web compatible.
  ///
  /// The UI should obtain the bytes using:
  ///
  /// FilePicker.pickFiles(
  ///   withData: true,
  /// )
  ///
  /// and then pass:
  ///
  /// fileBytes: file.bytes!
  /// fileName: file.name
  Future<bool> uploadDocument({
    required List<int> fileBytes,
    required String fileName,
  }) async {
    final space = state.selectedSpace;

    if (space == null) {
      state = state.copyWith(errorMessage: 'Please select a RAG Space first.');
      return false;
    }

    if (fileBytes.isEmpty) {
      state = state.copyWith(errorMessage: 'Selected file is empty.');
      return false;
    }

    if (fileName.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Selected file name is empty.');
      return false;
    }

    state = state.copyWith(isUploadingDocument: true, clearError: true);

    try {
      debugPrint(
        'RAG: Uploading $fileName '
        'to space ${space.id}',
      );

      await _repository.uploadDocument(
        spaceId: space.id,
        fileBytes: fileBytes,
        fileName: fileName,
      );

      debugPrint('RAG: Document upload completed');

      state = state.copyWith(isUploadingDocument: false);

      // Refresh the selected space so that:
      // - document list is updated
      // - document count is updated
      // - chunk count is updated
      await refreshSelectedSpace();

      return true;
    } catch (e) {
      debugPrint('RAG: Document upload failed: $e');

      state = state.copyWith(
        isUploadingDocument: false,
        errorMessage: _getErrorMessage(e),
      );

      return false;
    }
  }

  Future<RagDocument?> getDocument(String documentId) async {
    final space = state.selectedSpace;

    if (space == null) {
      state = state.copyWith(errorMessage: 'Please select a RAG Space first.');
      return null;
    }

    try {
      final document = await _repository.getDocument(
        spaceId: space.id,
        documentId: documentId,
      );

      state = state.copyWith(selectedDocument: document, clearError: true);

      return document;
    } catch (e) {
      state = state.copyWith(errorMessage: _getErrorMessage(e));

      return null;
    }
  }

  void clearSelectedDocument() {
    state = state.copyWith(clearSelectedDocument: true);
  }

  Future<bool> deleteDocument(String documentId) async {
    final space = state.selectedSpace;

    if (space == null) {
      state = state.copyWith(errorMessage: 'Please select a RAG Space first.');
      return false;
    }

    state = state.copyWith(isDeletingDocument: true, clearError: true);

    try {
      debugPrint('RAG: Deleting document $documentId');

      await _repository.deleteDocument(
        spaceId: space.id,
        documentId: documentId,
      );

      debugPrint('RAG: Document deleted successfully');

      state = state.copyWith(
        isDeletingDocument: false,
        clearSelectedDocument: true,
      );

      await refreshSelectedSpace();

      return true;
    } catch (e) {
      debugPrint('RAG: Document deletion failed: $e');

      state = state.copyWith(
        isDeletingDocument: false,
        errorMessage: _getErrorMessage(e),
      );

      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Space deletion / clearing
  // ---------------------------------------------------------------------------

  Future<bool> clearSpace(String spaceId) async {
    final space = state.spaces.where((item) => item.id == spaceId).firstOrNull;

    if (space != null && space.status.toUpperCase() == 'ACTIVE') {
      state = state.copyWith(
        errorMessage: 'ACTIVE RAG Spaces cannot be cleared.',
      );

      return false;
    }

    state = state.copyWith(isLoadingSpaces: true, clearError: true);

    try {
      debugPrint('RAG: Clearing space $spaceId');

      await _repository.deleteSpace(spaceId);

      state = state.copyWith(
        isLoadingSpaces: false,
        spaces: state.spaces.where((item) => item.id != spaceId).toList(),
      );

      if (state.selectedSpace?.id == spaceId) {
        state = state.copyWith(
          clearSelectedSpace: true,
          clearSelectedDocument: true,
          documents: const [],
          clearRetrievalResponse: true,
        );
      }

      debugPrint('RAG: Space cleared successfully');

      return true;
    } catch (e) {
      debugPrint('RAG: Clear space failed: $e');

      state = state.copyWith(
        isLoadingSpaces: false,
        errorMessage: _getErrorMessage(e),
      );

      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Retrieval
  // ---------------------------------------------------------------------------

  Future<void> retrieve({required String query, int topK = 5}) async {
    final space = state.selectedSpace;

    if (space == null) {
      state = state.copyWith(errorMessage: 'Please select a RAG Space first.');
      return;
    }

    if (query.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter a query.');
      return;
    }

    state = state.copyWith(
      isRetrieving: true,
      clearError: true,
      clearRetrievalResponse: true,
    );

    try {
      debugPrint('RAG: Retrieving for query: ${query.trim()}');

      final result = await _repository.retrieve(
        spaceId: space.id,
        query: query.trim(),
        topK: topK,
      );

      state = state.copyWith(isRetrieving: false, retrievalResponse: result);

      debugPrint('RAG: Retrieval completed');
    } catch (e) {
      debugPrint('RAG: Retrieval failed: $e');

      state = state.copyWith(
        isRetrieving: false,
        errorMessage: _getErrorMessage(e),
      );
    }
  }

  void clearRetrieval() {
    state = state.copyWith(clearRetrievalResponse: true, clearError: true);
  }

  // ---------------------------------------------------------------------------
  // Error handling
  // ---------------------------------------------------------------------------

  String _getErrorMessage(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
