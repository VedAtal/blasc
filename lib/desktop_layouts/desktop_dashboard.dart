import 'package:blasc/global_vars/Constants.dart';
import 'package:blasc/global_vars/header_builder.dart';
import 'package:flutter/material.dart';

class DesktopDashboard extends StatefulWidget {
  const DesktopDashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DesktopDashboard> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Constants.backgroundTeal,
      appBar: Header(
        currentHeight,
        currentWidth,
        'Home',
      ),
      // welcome text
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
                      fontSize: currentWidth * 0.022,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: Constants.homeIntro[1],
                        style: TextStyle(
                          color: Constants.teal1,
                          fontSize: currentWidth * 0.022,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      TextSpan(
                        text: Constants.homeIntro[2],
                        style: TextStyle(
                          fontSize: currentWidth * 0.022,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: currentHeight * 0.03),
                child: Text(
                  Constants.homeIntro[3],
                  style: TextStyle(
                    fontSize: currentWidth * 0.0175,
                    color: Constants.teal2,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: currentHeight * 0.03),
                child: Text(
                  Constants.homeIntro[4],
                  style: TextStyle(
                    fontSize: currentWidth * 0.0175,
                    color: Constants.teal2,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: currentHeight * 0.03),
                child: Text(
                  Constants.homeIntro[5],
                  style: TextStyle(
                    fontSize: currentWidth * 0.0175,
                    color: Constants.teal2,
                  ),
                ),
              ),
              Text(
                Constants.homeIntro[6],
                style: TextStyle(
                  fontSize: currentWidth * 0.022,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
