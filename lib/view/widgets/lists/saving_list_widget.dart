import 'package:flutter/material.dart';

class SavingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 10,right: 10),
        margin: EdgeInsets.only(left: 15 ,right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Budgets", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                Text("manage", style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
              ],
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Container(
//                child: ListView.separated(
//                    itemBuilder: (BuildContext context, int index) {
//                      Budget budget = budgets[index];
//                      return Container(
//                        padding: EdgeInsets.all(10),
//                        child: Column(
//                          children: <Widget>[
//                            Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                              children: <Widget>[
//                                Text(budget.name,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
//                                Text(budget.availableBalance.toString(),style:TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
//                              ],
//                            ),
//                            SizedBox(height: 10,),
//                            LinearProgressCard(double.infinity),
//                            SizedBox(height: 1,),
//                            LinearProgressCard(double.infinity),
//                          ],
//                        ),
//                      );
//                    },
//                    separatorBuilder: (BuildContext context, int index) {
//                      return Divider(
//                        thickness: 2,
//                      );
//                    },
//                    itemCount: budgets.length),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.30),
                  blurRadius: 6,
                  offset: Offset(3, 3))
            ],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))),
      ),
    );
  }
}