import 'package:blasc/main.dart';
import 'package:blasc/routes/noTransitionRoute.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blasc/global_vars/Constants.dart';
import 'package:blasc/global_vars/menu_builder.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final currentHeight;
  final currentWidth;
  final currentPage;

  const Header(this.currentHeight, this.currentWidth, this.currentPage,
      {Key? key})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(currentHeight * 0.075);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      toolbarHeight: currentHeight * 0.075,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // BLASC title
          Container(
            margin: EdgeInsets.only(left: currentWidth * 0.022),
            height: (currentHeight * 0.075) * 0.9,
            child: Center(
              child: InkWell(
                hoverColor: Colors.transparent,
                onTap: () {
                  Navigator.push(
                      context,
                      noTransitionRoute(
                          builder: (context) =>
                              Constants.pageRoutes['Home'] as Widget));
                },
                child: Text(
                  'BLASC',
                  style: TextStyle(
                    color: Constants.teal2,
                    fontSize: currentWidth > currentHeight
                        ? (currentHeight * 0.075) * 0.5
                        : (currentWidth * 0.05),
                  ),
                ),
              ),
            ),
          ),
          // app logo redirect and login button
          Container(
            margin: EdgeInsets.only(right: currentWidth * 0.02),
            height: (currentHeight * 0.075) * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: (currentHeight * 0.075) * 0.45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // app logo
                      Container(
                        margin: EdgeInsets.only(right: currentWidth * 0.005),
                        child: InkWell(
                          onTap: () {
                            Constants.BSredirect();
                          },
                          child: Image.asset(
                            'images/appLogo.jpg',
                            height: (currentHeight * 0.075) * 0.45,
                          ),
                        ),
                      ),
                      // sign out button
                      Container(
                        margin: EdgeInsets.only(right: currentWidth * 0.008),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Constants.teal2,
                            minimumSize: Size(
                              (currentWidth * 0.05),
                              (currentHeight * 0.075) * 0.45,
                            ),
                            maximumSize: Size(
                              (currentWidth * 0.2),
                              (currentHeight * 0.075) * 0.45,
                            ),
                          ),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Constants.user = null;
                            Navigator.push(
                                context,
                                noTransitionRoute(
                                    builder: (context) => const BLASC()));
                          },
                          child: Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: (currentHeight * 0.075) * 0.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...(Constants.pages).map((page) {
                      return Menu(currentWidth, currentHeight, page,
                          page == currentPage ? Constants.teal2 : Colors.black);
                    }).toList(),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
