import 'package:budget_app/models/debt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DebtList extends StatefulWidget {
  @override
  _DebtListState createState() => _DebtListState();
}

class _DebtListState extends State<DebtList> {
  @override
  Widget build(BuildContext context) {
    final debts = Provider.of<List<Debt>>(context) ?? [];

    debts.forEach((debt) {
      print(debt.amount);
    });
        print('debts$debts');
    return ListView.builder(
      itemCount: debts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(debts[index].name),
          trailing: Text(debts[index].amount.toString()),
        );
      },
    );
  }
}
