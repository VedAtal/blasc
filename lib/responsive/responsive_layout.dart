import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget desktopLayout;
  final Widget mobileLayout;

  const ResponsiveLayout(this.desktopLayout, this.mobileLayout, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600 &&
            constraints.maxWidth / constraints.maxHeight < 1.0) {
          return mobileLayout;
        } else {
          return desktopLayout;
        }
      },
    );
  }
}
