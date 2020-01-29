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

class CreateIncomeForm extends StatefulWidget {
  final Function loader;

  const CreateIncomeForm({Key key, this.loader}) : super(key: key);

  @override
  _CreateIncomeFormState createState() => _CreateIncomeFormState();
}

class _CreateIncomeFormState extends State<CreateIncomeForm> {
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
            Text("Create new income",
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
            Button(
              action: () async {
                if (_formKey.currentState.validate()) {
                  print(amount);
                  print(name);

                  widget.loader();
                  Income income = Income(
                      name: name,
                      amount: amount,
                      availableBalance: amount,
                      userId: user.uid,
                      createdAt: DateTime.now().toUtc());
                  dar.Either<Failure, void> result =
                      await incomeService.create(Params(income: income));
                  result.fold((ifLeft) => print('Failure'), (ifRight) {
                    print('Sucess');
                    Navigator.pop(context);
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
