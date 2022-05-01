import 'package:blasc/global_vars/Constants.dart';

class ImageRetriever {
  late String imageRef;
  late String imageURL;

  ImageRetriever(this.imageRef);

  Future<String?> getData() async {
    try {
      await downloadURL();
      return imageURL;
    } catch (e) {
      return null;
    }
  }

  Future<void> downloadURL() async {
    imageURL = await Constants.firebaseStorage.ref(imageRef).getDownloadURL();
  }
}
