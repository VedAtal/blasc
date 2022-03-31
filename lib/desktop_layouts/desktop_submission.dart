import 'package:blasc/desktop_layouts/desktop_submit.dart';
import 'package:blasc/global_vars/Constants.dart';
import 'package:blasc/global_vars/header_builder.dart';
import 'package:blasc/global_vars/mobile_message.dart';
import 'package:blasc/responsive/responsive_layout.dart';
import 'package:blasc/routes/noTransitionRoute.dart';
import 'package:flutter/material.dart';

class DesktopSubmission extends StatefulWidget {
  const DesktopSubmission({Key? key}) : super(key: key);

  @override
  _SubmissionState createState() => _SubmissionState();
}

class _SubmissionState extends State<DesktopSubmission> {
  @override
  Widget build(BuildContext context) {
    // screen deimensions
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Constants.backgroundTeal,
      appBar: Header(
        currentHeight,
        currentWidth,
        'Submission',
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(
          currentWidth * 0.2,
          currentHeight * 0.15,
          currentWidth * 0.2,
          currentHeight * 0.2,
        ),
        // submit message and submit button
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // submit message
            Container(
              margin: EdgeInsets.only(
                bottom: currentWidth * 0.02,
              ),
              child: Text(
                'Here you can create your own learning adventure! Tap on the buttom'
                ' below to get started. Fill out all the presented fields and click submit'
                ' when you\'re done. Our curators will review your submission and you will'
                ' be notified about its status which you will be able to view in the status tab.',
                style: TextStyle(
                  fontSize: currentWidth * 0.022,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // submit message
            ElevatedButton(
              child: Text(
                'Submit an Adventure',
                style: TextStyle(
                  fontSize: currentWidth * 0.02,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  noTransitionRoute(
                    builder: (context) => const ResponsiveLayout(
                      DesktopSubmit(),
                      MobileMessage(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Constants.teal1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
