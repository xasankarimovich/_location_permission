import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageServices {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadFile(String fileName, File file) async {
    final imageReference = _storage.ref().child('travels/images/$fileName.jpg');
    final uploadTask = imageReference.putFile(file);
    uploadTask.snapshotEvents.listen((event) {
      print(event.state);
      int percentage = (event.bytesTransferred * 100 / file.lengthSync()).round();
      print("Yuklandi $percentage%");
    });
    String imageUrl = '';
    await uploadTask.whenComplete(() async {
      imageUrl = await imageReference.getDownloadURL();
    });
    print(imageUrl);
    return imageUrl;
  }
}
