import 'dart:io';

import 'package:drill_events/common/ports/file_storage.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:firebase_storage/firebase_storage.dart';

final class FileFirebaseStorage extends FileStorage {
  FileFirebaseStorage(this._firebaseStorage, this._logger);

  final FirebaseStorage _firebaseStorage;
  // final Reference _storageRef;
  final Logger _logger;

  static const _mainFolderName = 'UsersAvatars';

  @override
  Future<String?> putFile({required File file, required String id}) async {
    try {
      final ref = _firebaseStorage.ref();
      final mountainsImageRef = ref.child('$_mainFolderName/$id');
      await mountainsImageRef.putFile(file);
      final avatarUrl = await mountainsImageRef.getDownloadURL();
      return avatarUrl;
    } on FirebaseException catch (error, stackTrace) {
      _logger.error('FileFirebaseStorage', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<String?> getFileDownloadUrl(String id) async {
    try {
      final ref = _firebaseStorage.ref();
      final imageUrl = await ref.child('$_mainFolderName/$id').getDownloadURL();
      return imageUrl;
    } on FirebaseException catch (error, stackTrace) {
      _logger.error('FileFirebaseStorage', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteFile() {
    throw UnimplementedError();
  }
}
