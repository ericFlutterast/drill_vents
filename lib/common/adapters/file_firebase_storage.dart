import 'dart:io';

import 'package:drill_events/common/ports/file_storage.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract final class StorageDirectory {
  static const userAvatars = 'UsersAvatars';
  static const orgAvatars = 'OrgAvatars';
}

final class FileFirebaseStorage implements FileStorage {
  FileFirebaseStorage(this._firebaseStorage, this._logger);

  final FirebaseStorage _firebaseStorage;
  final Logger _logger;

  //TODO:Временное решение
  @override
  Future<List<String?>> getListFileDownloadUrl(Iterable<String> paths) async {
    final request = [for (final path in paths) getFileDownloadUrl(path)];
    return await Future.wait(request);
  }

  @override
  Future<String?> putFile({required File file, required String path}) async {
    try {
      final ref = _firebaseStorage.ref();
      final mountainsImageRef = ref.child(path);
      await mountainsImageRef.putFile(file);
      final avatarUrl = await mountainsImageRef.getDownloadURL();
      return avatarUrl;
    } on FirebaseException catch (error, stackTrace) {
      _logger.error('FileFirebaseStorage', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<String?> getFileDownloadUrl(String path) async {
    try {
      final ref = _firebaseStorage.ref();

      final imageUrl = await ref.child(path).getDownloadURL();
      return imageUrl;
    } on FirebaseException catch (error, stackTrace) {
      _logger.error('FileFirebaseStorage', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<void> deleteFile() {
    throw UnimplementedError();
  }
}
