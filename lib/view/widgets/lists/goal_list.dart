import 'package:budget_app/models/goal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoalList extends StatefulWidget {
  @override
  _GoalListState createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> {
  @override
  Widget build(BuildContext context) {
    final goals = Provider.of<List<Goal>>(context) ?? [];

    goals.forEach((goal) {
      print(goal.amount);
    });
        print('goals$goals');
    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(goals[index].name),
          trailing: Text(goals[index].amount.toString()),
        );
      },
    );
  }
}
