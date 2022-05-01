import 'package:blasc/global_vars/Constants.dart';
import 'package:blasc/global_vars/image_generator.dart';
import 'package:flutter/material.dart';

class MobileMessage extends StatelessWidget {
  const MobileMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Constants.backgroundTeal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'The mobile site is currently under development. Please'
              ' visit the site on desktop to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: currentWidth * 0.05,
              ),
            ),
            Image.asset(
              'images/homePage.jpg',
              height: currentWidth * 0.5,
            ),
          ],
        ),
      ),
    );
  }
}
