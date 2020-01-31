import 'dart:ui';

import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/expense.dart';
import 'package:budget_app/models/income.dart';
import 'package:budget_app/service/expense_service.dart';
import 'package:budget_app/util/decoration/constants.dart';
import 'package:budget_app/view/forms/update_expense_form.dart';
import 'package:dartz/dartz.dart' as dar;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';

class ExpenseDescriptionWidget extends StatefulWidget {
  final Function loader;
  final Income income;
  final List<Income> incomes;

  const ExpenseDescriptionWidget(
      {Key key, this.loader, this.income, this.incomes})
      : super(key: key);

  @override
  _ExpenseDescriptionWidgetState createState() =>
      _ExpenseDescriptionWidgetState();
}

class _ExpenseDescriptionWidgetState extends State<ExpenseDescriptionWidget> {
  final expenseService = sl.get<ExpenseService>();

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<List<Expense>>(context) ?? [];

    void _showDeleteModal(Expense expense) {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Delete expense ${expense.name}"),
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
                    widget.loader();
                    dar.Either<Failure, void> result =
                        await expenseService.deleteExpense(expense.id);
                    result.fold((ifLeft) => print('Failure'), (ifRight) {
                      print('Success');
                      widget.loader();
                    });
                  },
                )
              ],
            );
          });
    }

    void _showUpdatePanel(Expense expense, Income income) {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: UpdateExpenseForm(
                  expense: expense,
                  incomes: widget.incomes,
                  income: income,
                  loader: widget.loader,
                ),
              ),
            );
          });
    }

    print("asdfghjkl   ${expenses.length}");

    return expenses.length == 0
        ? Center(
            child: Text("No expense found", style: TextStyle(fontSize: 25),),
          )
        : ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (BuildContext context, int index) {

              print("asdfghjkl   ${expenses[index].id}");
              print("asdfghjkl   ${widget.income.name}");
              print("hdksjdsiewoh   ${widget.incomes}");
              print("hdksjdsiewo ${expenses.length == 0}");
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: containerDecoration,
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      expenses[index].name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Cost N${expenses[index].cost.floor()}',
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
                        expenses[index].expenseType ?? "Save",
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
                        widget.income.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
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
                            _showUpdatePanel(expenses[index], widget.income);
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
                            _showDeleteModal(expenses[index]);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
  }
}
