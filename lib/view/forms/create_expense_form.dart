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

class CreateExpenseForm extends StatefulWidget {
  final Function loader;
  final List<Income> incomes;

  const CreateExpenseForm({Key key, this.loader, this.incomes})
      : super(key: key);

  @override
  _CreateExpenseFormState createState() => _CreateExpenseFormState();
}

class _CreateExpenseFormState extends State<CreateExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final incomeService = sl.get<IncomeService>();
  final expenseService = sl.get<ExpenseService>();
  String error = '';
  String name = '';
  double cost = 0.0;
  Income income;
  String type;

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
            Text("Create new Expense",
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
              decoration: textInputDecoration.copyWith(
                hintText: 'name',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Name is required';
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
              decoration: textInputDecoration.copyWith(
                hintText: 'Cost',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Cost is required';
                }
                return null;
              },
              onChanged: (val) {
                setState(() {
                  cost = double.parse(val);
                });
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
              value: income,
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
                  income = val;
                  print('income.name${income.name}');
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
              hint: Text('Expense type'),
              value: type,
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
                return null;
              },
              onChanged: (val) {
                setState(() {
                  print('val$val');
                  type = val;
                  print('type.name$type}');
                });
              },
            ),
            Button(
              action: () async {
                if (_formKey.currentState.validate()) {
                  Navigator.pop(context);
                  print('cost$cost');
                  print('name$name');

                  widget.loader();
                  Expense expense = Expense(
                      name: name,
                      cost: cost,
                      income: income.id,
                      userId: user.uid,
                      expenseType: type,
                      createdAt: DateTime.now().toUtc());
                  dar.Either<Failure, void> result =
                      await expenseService.create(ParamsExp(expense: expense));
                  result.fold((ifLeft) => print('ifLeft$ifLeft'), (ifRight) {
                    print('Sucess');
                    widget.loader();
                  });
                }
              },
              name: "Create",
            ),
          ],
        ),
      ),
    );
  }
}
