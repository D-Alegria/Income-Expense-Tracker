import 'package:budget_app/injection_container.dart';
import 'package:budget_app/models/user.dart';
import 'package:budget_app/service/expense_service.dart';
import 'package:budget_app/util/decoration/button_widget.dart';
import 'package:budget_app/view/widgets/charts/income_chart_widget.dart';
import 'package:budget_app/view/widgets/lists/goal_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoalPage extends StatefulWidget {
  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  final ExpenseService expenseService = sl.get<ExpenseService>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamProvider.value(
      value: expenseService.getAllByUserIdStream(user.uid),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            IncomeChart(),
//          Container(
//            color: Colors.grey,
//            height: MediaQuery.of(context).size.height * 1 / 3,
//          ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 16),child: Button(action: () {
              print("Create goal");
            },name: "Create Goal",),),

            Expanded(child: GoalList())
          ],
        ),
      ),
    );
  }
}
