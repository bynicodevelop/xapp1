import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageProvider {
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> _uploadFile(String path, String storagePath) async {
    Reference reference = _firebaseStorage.ref().child(storagePath);

    File file = File(path);

    UploadTask task = reference.putFile(file);

    await task;

    return await reference.getDownloadURL();
  }

  Future<String> uploadToFeed(String path, String userId) async {
    String fileName = path.split('/').last;

    String fileNameToMD5 = md5.convert(utf8.encode(fileName)).toString();

    String storagePath = '/users/$userId/feed/$fileNameToMD5.jpeg';

    return await _uploadFile(path, storagePath);
  }
}
