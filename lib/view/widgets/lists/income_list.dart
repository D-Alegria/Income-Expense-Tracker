import 'package:budget_app/models/income.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncomeList extends StatefulWidget {
  @override
  _IncomeListState createState() => _IncomeListState();
}

class _IncomeListState extends State<IncomeList> {
  @override
  Widget build(BuildContext context) {
    final incomes = Provider.of<List<Income>>(context) ?? [];
    return ListView.builder(
      itemCount: incomes.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(incomes[index].name),
          trailing: Text(incomes[index].amount.toString()),
        );
      },
    );
  }
}
