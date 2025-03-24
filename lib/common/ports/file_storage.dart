import 'dart:io';

abstract class FileStorage {
  Future<String?> putFile({required File file, required String path});
  Future<String?> getFileDownloadUrl(String path);
  Future<void> deleteFile();

  //TODO: Временное решение
  Future<Iterable<String?>> getListFileDownloadUrl(Iterable<String> list);
}
