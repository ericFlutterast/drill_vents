import 'dart:io';

abstract class FileStorage {
  Future<String?> putFile({required File file, required String id});
  Future<String?> getFileDownloadUrl(String id);
  Future<void> deleteFile();
}
