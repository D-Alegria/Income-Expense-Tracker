import 'package:budget_app/models/expense.dart';
import 'package:budget_app/models/income.dart';
import 'package:budget_app/service/expense_service.dart';
import 'package:budget_app/util/decoration/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';
import 'expense_description_widget.dart';

class ExpenseDescriptionProvider extends StatefulWidget {

  final Function loader;
  final Income income;
  final List<Income> incomes;

  const ExpenseDescriptionProvider({Key key, this.loader, this.income, this.incomes}) : super(key: key);

  @override
  _ExpenseDescriptionProviderState createState() =>
      _ExpenseDescriptionProviderState();
}

class _ExpenseDescriptionProviderState extends State<ExpenseDescriptionProvider> {
  final expenseService = sl.get<ExpenseService>();
  bool loading = false;

  void toggleLoader() {
    setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {


    print("expense(jce ${widget.income}income");
    print("expense(ewwe ${widget.incomes}income");
    return loading
        ? Loader()
        : StreamProvider<List<Expense>>.value(
            value:  expenseService.getAllByIncomeId(widget.income.id),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 10,
                title: Text("Expense Manager"),
                centerTitle: true,
              ),
              body: ExpenseDescriptionWidget(
                loader: toggleLoader,
                income: widget.income,
                incomes: widget.incomes,
              ),
            ),
          );
  }
}
