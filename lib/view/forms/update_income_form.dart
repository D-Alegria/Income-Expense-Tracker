//import 'package:budget_app/models/user.dart';
import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/income.dart';
import 'package:budget_app/models/user.dart';
import 'package:budget_app/service/income_service.dart';
import 'package:budget_app/util/decoration/button_widget.dart';
import 'package:budget_app/util/decoration/constants.dart';
import 'package:dartz/dartz.dart' as dar;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';

import '../../injection_container.dart';

class UpdateIncomeForm extends StatefulWidget {
  final Function loader;
  final Income income;

  const UpdateIncomeForm({Key key, this.loader, this.income}) : super(key: key);

  @override
  _UpdateIncomeFormState createState() => _UpdateIncomeFormState();
}

class _UpdateIncomeFormState extends State<UpdateIncomeForm> {
  final _formKey = GlobalKey<FormState>();
  final incomeService = sl.get<IncomeService>();
  String error = '';
  String name = '';
  double amount = 0.0;


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
            Text("Update income",
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
              initialValue: widget.income.name,
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
              initialValue: widget.income.amount.toString(),
              enabled: false,
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
            Button(
              action: () async {
                if (_formKey.currentState.validate()) {
                  Navigator.pop(context);
                  widget.loader();
                  print(amount);
                  print(name);

                  Income income = Income(
                      id: widget.income.id,
                      name: name,
                      amount: widget.income.amount,
                      userId: user.uid,
                      createdAt: widget.income.createdAt,
                      );
                  dar.Either<Failure, void> result =
                      await incomeService.updateIncome(income);
                  result.fold((ifLeft) => print('Failure'), (ifRight) {
                    print('Success');
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