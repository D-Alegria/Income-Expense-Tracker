import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/debt.dart';
import 'package:budget_app/models/income.dart';
import 'package:budget_app/models/user.dart';
import 'package:budget_app/service/debt_service.dart';
import 'package:budget_app/service/income_service.dart';
import 'package:budget_app/util/decoration/button_widget.dart';
import 'package:budget_app/util/decoration/constants.dart';
import 'package:dartz/dartz.dart' as dar;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../injection_container.dart';

class CreateDebtForm extends StatefulWidget {
  final Function loader;
  final List<Income> incomes;

  const CreateDebtForm({Key key, this.loader, this.incomes})
      : super(key: key);

  @override
  _CreateDebtFormState createState() => _CreateDebtFormState();
}

class _CreateDebtFormState extends State<CreateDebtForm> {
  final _formKey = GlobalKey<FormState>();
  final incomeService = sl.get<IncomeService>();
  final debtService = sl.get<DebtService>();
  String error = '';
  String name = '';
  double amount = 0.0;
  Income income;// = ;

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
            Text("Create new Debt",
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
                hintText: 'Amount',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Amount is required';
                }
                return null;
              },
              onChanged: (val) {
                setState(() {
                  amount = double.parse(val);
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
              value: income,
              items: widget.incomes.map((Income doc) {
                return DropdownMenuItem(
                    value: doc, child: Text('Income ${doc.name}'));
              }).toList(),
              validator: (val){
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
            Button(
              action: () async {
                if (_formKey.currentState.validate()) {
                  Navigator.pop(context);
                  print('amount$amount');
                  print('name$name');

                  widget.loader();
                  Debt debt = Debt(
                      name: name,
                      amount: amount,
                      income: income.id,
                      userId: user.uid,
                      createdAt: DateTime.now().toUtc());
                  dar.Either<Failure, void> result =
                      await debtService.create(ParamsExp(debt: debt));
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