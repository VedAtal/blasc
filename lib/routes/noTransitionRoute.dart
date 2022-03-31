import 'package:flutter/material.dart';

class noTransitionRoute<T> extends MaterialPageRoute<T> {
  noTransitionRoute({required WidgetBuilder builder}) : super(builder: builder);
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
