import 'package:blasc/global_vars/Constants.dart';
import 'package:blasc/global_vars/header_builder.dart';
import 'package:flutter/material.dart';

class MobileDashboard extends StatefulWidget {
  const MobileDashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<MobileDashboard> {
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
        'Home',
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(
          currentWidth * 0.1,
          currentHeight * 0.1,
          currentWidth * 0.1,
          currentHeight * 0.1,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: currentHeight * 0.03),
                child: RichText(
                  text: TextSpan(
                    text: Constants.homeIntro[0],
                    style: TextStyle(
                      fontSize: currentWidth * 0.03,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: Constants.homeIntro[1],
                        style: TextStyle(
                          color: Constants.teal1,
                          fontSize: currentWidth * 0.03,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      TextSpan(
                        text: Constants.homeIntro[2],
                        style: TextStyle(
                          fontSize: currentWidth * 0.03,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: currentHeight * 0.03),
                child: Text(
                  Constants.homeIntro[3],
                  style: TextStyle(
                    fontSize: currentWidth * 0.0275,
                    color: Constants.teal2,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: currentHeight * 0.03),
                child: Text(
                  Constants.homeIntro[4],
                  style: TextStyle(
                    fontSize: currentWidth * 0.0275,
                    color: Constants.teal2,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: currentHeight * 0.03),
                child: Text(
                  Constants.homeIntro[5],
                  style: TextStyle(
                    fontSize: currentWidth * 0.0275,
                    color: Constants.teal2,
                  ),
                ),
              ),
              Text(
                Constants.homeIntro[6],
                style: TextStyle(
                  fontSize: currentWidth * 0.03,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
