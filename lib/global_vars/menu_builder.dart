import 'package:blasc/routes/noTransitionRoute.dart';
import 'package:flutter/material.dart';
import 'package:blasc/global_vars/Constants.dart';

class Menu extends StatelessWidget {
  final currentWidth;
  final currentHeight;
  final title;
  final Color isSelected;

  const Menu(this.currentWidth, this.currentHeight, this.title, this.isSelected,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          currentWidth > currentHeight ? (currentHeight * 0.075) * 0.4 : null,
      margin: EdgeInsets.fromLTRB(
        currentWidth * 0.008,
        currentHeight * 0.001,
        currentWidth * 0.008,
        currentHeight * 0.001,
      ),
      child: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.push(
              context,
              noTransitionRoute(
                  builder: (context) => Constants.pageRoutes[title] as Widget));
        },
        child: FittedBox(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected,
              fontSize: currentWidth > currentHeight
                  ? currentWidth * 0.014
                  : currentHeight * 0.015,
            ),
          ),
        ),
      ),
    );
  }
}
