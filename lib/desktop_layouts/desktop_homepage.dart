import 'package:blasc/desktop_layouts/desktop_login.dart';
import 'package:blasc/global_vars/image_generator.dart';
import 'package:blasc/global_vars/mobile_message.dart';
import 'package:flutter/material.dart';
import 'package:blasc/global_vars/Constants.dart';
import 'package:blasc/routes/popUpRoute.dart';
import 'package:blasc/responsive/responsive_layout.dart';

class DesktopHomepage extends StatefulWidget {
  const DesktopHomepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<DesktopHomepage> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Constants.backgroundTeal,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: currentHeight * 0.075,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // BLASC title
            Container(
              margin: EdgeInsets.only(left: currentWidth * 0.02),
              height: (currentHeight * 0.075) * 0.9,
              child: Center(
                child: Text(
                  'BLASC',
                  style: TextStyle(
                    color: Constants.teal2,
                    fontSize: (currentHeight * 0.075) * 0.5,
                  ),
                ),
              ),
            ),
            // app logo redirect and login button
            Container(
              margin: EdgeInsets.only(right: currentWidth * 0.02),
              height: (currentHeight * 0.075) * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // app logo
                  Container(
                    margin: EdgeInsets.only(right: currentWidth * 0.01),
                    child: InkWell(
                      onTap: () {
                        Constants.BSredirect();
                      },
                      child: Image.asset(
                        'images/appLogo.jpg',
                        height: (currentHeight * 0.075) * 0.7,
                      ),
                    ),
                  ),
                  // login button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Constants.teal2,
                      minimumSize: Size(
                        (currentWidth * 0.05),
                        (currentHeight * 0.075) * 0.6,
                      ),
                      maximumSize: Size(
                        (currentWidth * 0.2),
                        (currentHeight * 0.075) * 0.6,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PopUpRoute(
                          builder: (context) => const ResponsiveLayout(
                            DesktopLogin(),
                            MobileMessage(),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: (currentHeight * 0.075) * 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        // home logo and welcome message
        child: SizedBox(
          height: currentHeight * 0.75,
          width: currentWidth * 0.5,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: currentHeight * 0.02,
                ),
                child: FittedBox(
                  // welcome message
                  child: Text(
                    'Welcome! Login to start viewing \nand submitting Learning Adventures!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: (currentWidth * 0.5) * 0.1,
                    ),
                  ),
                ),
              ),
              // home logo
              Image.asset(
                'images/homePage.jpg',
                width: (currentWidth * 0.5) * 0.9,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
