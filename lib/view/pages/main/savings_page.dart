import 'package:budget_app/view/widgets/progress_bar/circular_progress_bar.dart';
import 'package:budget_app/view/widgets/single_shadow_decoration_container.dart';
import 'package:flutter/material.dart';

class SavingsPage extends StatefulWidget {
  @override
  _SavingsPageState createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
          height: 91,
          width: double.infinity,
          margin: EdgeInsets.only(left: 17, top: 17, right: 17),
          padding: EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Total"),
              Text(
                "N7282",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 31),
              )
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.44),
                    blurRadius: 6,
                    offset: Offset(3, 3))
              ],
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        SingleShadowContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Income",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 5,),
                Row(
                  children: <Widget>[
                    CircularProgressCard(40),
                    SizedBox(width: 10,),
                    CircularProgressCard(40),
                    SizedBox(width: 10,),
                    CircularProgressCard(40),
                    SizedBox(width: 10,),
                  ],
                ),
              ],
            ),
            margin: EdgeInsets.only(left: 17, top: 17, right: 17),
            padding: EdgeInsets.only(left: 15, top: 12),
            height: 91),
        SizedBox(
          height: 20,
        ),
//        Expanded(
////          child: SavingsList(),
//        )
      ],
    ));
  }
}
