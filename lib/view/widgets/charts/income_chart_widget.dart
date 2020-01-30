import 'package:budget_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class IncomeChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<List<Expense>>(context) ?? [];

    List<charts.Series<Expense, String>> series = [
      charts.Series(
          id: "Expenses",
          data: expenses,
          domainFn: (Expense series, _) => series.cost.toString(),
          measureFn: (Expense series, _) => series.createdAt.day,
          colorFn: (Expense series, _) =>
              charts.ColorUtil.fromDartColor(Colors.blue))
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 1 / 3,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Column(
          children: <Widget>[
            Text(
              "Expenses per Day",
              style: Theme.of(context).textTheme.body2,
            ),
            Expanded(
              child: charts.BarChart(series, animate: true),
            )
          ],
        ),
      ),
    );
  }
}
