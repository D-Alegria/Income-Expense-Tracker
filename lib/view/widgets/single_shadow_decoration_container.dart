import 'package:flutter/material.dart';

class SingleShadowContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double height;

  const SingleShadowContainer(
      {Key key,
      @required this.child,
      @required this.margin,
      @required this.padding,
      @required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      padding: padding,
      child: child,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.44),
                blurRadius: 6,
                offset: Offset(3, 3))
          ],
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}
