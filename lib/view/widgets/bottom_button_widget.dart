import 'package:budget_app/util/decoration/button_widget.dart';
import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
            height: 60,
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Cost: N 2483943"),
                  ),
                ),
                Expanded(child: Button(action: (){}, name: 'Continue'))
              ],
            )),
      ],
    );
  }
}