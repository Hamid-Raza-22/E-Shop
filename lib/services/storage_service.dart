import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

/// Uploads product artwork to Firebase Storage.
///
/// Bytes are uploaded rather than a `File` so the same code path works on the
/// web, where `image_picker` cannot give a filesystem path.
class StorageService {
  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  static const String productFolder = "products";

  /// Stores [bytes] and returns the public download URL.
  ///
  /// [fileName] only supplies the extension and a readable name; the object name
  /// is prefixed with a timestamp so re-uploading never overwrites an image that
  /// an existing product still points at.
  Future<String> uploadProductImage({
    required Uint8List bytes,
    required String fileName,
    String? contentType,
  }) async {
    final safeName = fileName
        .split(RegExp(r"[\\/]"))
        .last
        .replaceAll(RegExp(r"[^a-zA-Z0-9._-]"), "_");
    final objectName =
        "${DateTime.now().millisecondsSinceEpoch}_${safeName.isEmpty ? "image" : safeName}";

    final reference = _storage.ref().child(productFolder).child(objectName);
    await reference.putData(
      bytes,
      SettableMetadata(contentType: contentType ?? _contentTypeFor(safeName)),
    );
    return reference.getDownloadURL();
  }

  /// Deletes a previously uploaded image, ignoring an already-missing object.
  Future<void> deleteByUrl(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } on FirebaseException {
      // Nothing to delete, or the URL is not a Storage object.
    }
  }

  String _contentTypeFor(String fileName) {
    final extension = fileName.toLowerCase().split(".").last;
    return switch (extension) {
      "png" => "image/png",
      "webp" => "image/webp",
      "gif" => "image/gif",
      "heic" => "image/heic",
      _ => "image/jpeg",
    };
  }
}
