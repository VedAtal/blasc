import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MobileAdventurePage extends StatelessWidget {
  final DocumentSnapshot document;
  const MobileAdventurePage(this.document, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.fromLTRB(
        currentWidth * 0.1,
        currentHeight * 0.1,
        currentWidth * 0.1,
        currentWidth * 0.1,
      ),
      child: const Material(
        child: Text(
          'placeholder',
        ),
      ),
    );
  }
}

// MOBILE DEVELOPMENT IN THE FUTURE