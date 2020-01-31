import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/enums/expenseType.dart';
import 'package:budget_app/models/expense.dart';
import 'package:budget_app/models/income.dart';
import 'package:budget_app/models/user.dart';
import 'package:budget_app/service/expense_service.dart';
import 'package:budget_app/service/income_service.dart';
import 'package:budget_app/util/decoration/button_widget.dart';
import 'package:budget_app/util/decoration/constants.dart';
import 'package:dartz/dartz.dart' as dar;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../injection_container.dart';

// ignore: must_be_immutable
class UpdateExpenseForm extends StatefulWidget {
  final Function loader;
  final List<Income> incomes;
  Income income;
  Expense expense;
  String type;

  UpdateExpenseForm(
      {Key key, this.loader, this.incomes, this.expense, this.income}) {
//    super(key: key);
    this.type = expense.expenseType;
  }

  @override
  _UpdateExpenseFormState createState() => _UpdateExpenseFormState();
}

class _UpdateExpenseFormState extends State<UpdateExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final incomeService = sl.get<IncomeService>();
  final expenseService = sl.get<ExpenseService>();
  String error = '';
  String name = '';
  double cost = 0.0;
  Income income;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text("Update Expense",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            SizedBox(
              height: 10,
            ),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: widget.expense.name,
              decoration: textInputDecoration.copyWith(
                hintText: 'name',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Name is required';
                }
                if(value.isNotEmpty){
                  setState(() {
                    name = value;
                  });
                }
                return null;
              },
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              initialValue: widget.expense.cost.toString(),
              decoration: textInputDecoration.copyWith(
                hintText: 'Cost',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Cost is required';
                }
                if(value.isNotEmpty){
                  cost = double.parse(value);
                }
                return null;
              },
              onChanged: (val) {
                setState(
                  () {
                    cost = double.parse(val);
                  },
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
              hint: Text('Select an income'),
              decoration: textInputDecoration.copyWith(
                isDense: true,
              ),
              value: widget.income,
              items: widget.incomes.map((Income doc) {
                return DropdownMenuItem<Income>(
                    value: doc, child: Text('Income ${doc.name}'));
              }).toList(),
              validator: (val) {
                if (val == null) {
                  return 'Income is required';
                }
                return null;
              },
              onChanged: (val) {
                setState(() {
                  print('val$val');
                  widget.income = val;
                  print('income.name${widget.income.name}');
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
              hint: Text('Expense type'),
              value: widget.type,
              decoration: textInputDecoration.copyWith(
                isDense: true,
              ),
              items: expenseType.map(
                (type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text('$type'),
                  );
                },
              ).toList(),
              validator: (val) {
                if (val == null) {
                  return 'A type is required';
                }

                if (val != null){
                  setState(
                        () {
                      print('val$val');
                      widget.type = val;
                      print('type.name${widget.type}');
                    },
                  );
                }
                return null;
              },
              onChanged: (val) {
                setState(
                  () {
                    print('val$val');
                    widget.type = val;
                    print('type.name${widget.type}');
                  },
                );
              },
            ),
            Button(
              action: () async {
                if (_formKey.currentState.validate()) {
                  Navigator.pop(context);
                  print('costly$cost');
                  print('name$name');

                  widget.loader();
                  Expense expense = Expense(
                      id: widget.expense.id,
                      name: name,
                      cost: cost,
                      income: widget.income.id,
                      userId: user.uid,
                      expenseType: widget.type,
                      createdAt: DateTime.now().toUtc());
                  dar.Either<Failure, void> result =
                      await expenseService.updateExpense(expense);
                  result.fold((ifLeft) => print('ifLeft$ifLeft'), (ifRight) {
                    print('Sucess');
                    widget.loader();
                  });
                }
              },
              name: "Update",
            ),
          ],
        ),
      ),
    );
  }
}
