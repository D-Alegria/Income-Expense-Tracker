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

class DeleteIncomeForm extends StatefulWidget {
  final Function loader;
  final Income income;

  const DeleteIncomeForm({Key key, this.loader, this.income}) : super(key: key);

  @override
  _DeleteIncomeFormState createState() => _DeleteIncomeFormState();
}

class _DeleteIncomeFormState extends State<DeleteIncomeForm> {
  final _formKey = GlobalKey<FormState>();
  final incomeService = sl.get<IncomeService>();
  String error = '';
  String name = '';
  double amount = 0.0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Center(
      heightFactor: 20,
      widthFactor: 50,
      child: Container(
        child: Column(children: <Widget>[
          Text("Are You sure?"),
          Button(action: (){}, name: "Delete")
        ],),
      ),
    );
  }
}
