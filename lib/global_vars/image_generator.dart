import 'package:blasc/global_vars/image_retriever.dart';
import 'package:flutter/material.dart';

class ImageGenerator extends StatelessWidget {
  late String imageRef;
  late var imageHeight;
  late var imageWidth;

  ImageGenerator(this.imageRef, this.imageHeight, this.imageWidth, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ImageRetriever(imageRef).getData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('');
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Image.network(
            snapshot.data.toString(),
            height: imageHeight,
            width: imageWidth,
          );
        }
        return const Text('');
      },
    );
  }
}
