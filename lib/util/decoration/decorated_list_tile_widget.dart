import 'package:budget_app/util/decoration/constants.dart';
import 'package:flutter/material.dart';

class DecoratedListTile extends StatelessWidget {

  final Widget listTile;

  const DecoratedListTile({Key key, this.listTile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: containerDecoration,
      child: this.listTile,
    );
  }
}
