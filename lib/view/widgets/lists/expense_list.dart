import 'package:budget_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseList extends StatefulWidget {
  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<List<Expense>>(context) ?? [];

    expenses.forEach((expense) {
      print(expense.name);
    });
        print('expenses$expenses');
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(expenses[index].name),
          subtitle: Text(expenses[index].createdAt.toLocal().toString()),
          trailing: Text('- ${expenses[index].cost.toString()}'),
        );
      },
    );
  }
}
