import 'package:flutter/material.dart';

class PopUpRoute<T> extends PageRoute<T> {
  PopUpRoute({
    required WidgetBuilder builder,
    bool fullscreenDialog = false,
  }) : builder = builder;

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black45;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}
