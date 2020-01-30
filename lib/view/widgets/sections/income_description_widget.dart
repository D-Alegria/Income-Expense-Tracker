import 'dart:ui';

import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/expense.dart';
import 'package:budget_app/models/income.dart';
import 'package:budget_app/models/user.dart';
import 'package:budget_app/service/expense_service.dart';
import 'package:budget_app/service/income_service.dart';
import 'package:budget_app/util/decoration/constants.dart';
import 'package:budget_app/util/decoration/loader.dart';
import 'package:budget_app/view/forms/update_income_form.dart';
import 'package:budget_app/view/widgets/progress_bar/linear_progress_bar.dart';
import 'package:dartz/dartz.dart' as dar;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';

class IncomeDescriptionWidget extends StatefulWidget {
  @override
  _IncomeDescriptionWidgetState createState() =>
      _IncomeDescriptionWidgetState();
}

class _IncomeDescriptionWidgetState extends State<IncomeDescriptionWidget> {
  final expenseService = sl.get<ExpenseService>();
  final incomeService = sl.get<IncomeService>();
  bool loading = false;

  void toggleLoader() {
    setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final incomes = Provider.of<List<Income>>(context) ?? [];

    void _showDeleteModal(Income income) {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Delete Income ${income.name}"),
              content: Text(
                "Are you sure?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No"),
                  splashColor: Colors.grey,
                ),
                RaisedButton(
                  color: Colors.red,
                  splashColor: Colors.deepOrangeAccent,
                  child: Text(
                    "Delete",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    toggleLoader();
                    dar.Either<Failure, void> result =
                        await incomeService.deleteIncome(income.id);
                    result.fold((ifLeft) => print('Failure'), (ifRight) {
                      print('Success');
                      toggleLoader();
                    });
                  },
                )
              ],
            );
          });
    }

    void _showAddPanel(Income income) {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: UpdateIncomeForm(
                  income: income,
                  loader: toggleLoader,
                ),
              ),
            );
          });
    }

    return loading
        ? Loader()
        : StreamProvider<List<Expense>>.value(
            value: expenseService.getAllByUserIdStream(user.uid),
            child: ListView.builder(
              itemCount: incomes.length,
              itemBuilder: (BuildContext context, int index) {
                final expenses = Provider.of<List<Expense>>(context) ?? [];

                Income income = incomes[index];
                double balance = 0;
                expenses.forEach((expense) {
                  if (expense.income == income.id) {
                    balance += expense.cost;
                  }
                });

                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: containerDecoration,
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        incomes[index].name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Amount ${income.amount}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Balance ${income.amount - balance}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${(((income.amount - balance) / income.amount) * 100).toString()}% remaining',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: LinearProgressCard(
                          width: double.infinity,
                          progressPercent:
                              ((income.amount - balance) / income.amount),
                          thickness: 3,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              _showAddPanel(income);
                            },
                            child: Text("update"),
                            splashColor: Colors.grey,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          RaisedButton(
                            color: Colors.red,
                            splashColor: Colors.deepOrangeAccent,
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                            onPressed: () {
                              _showDeleteModal(income);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          );
  }
}
