import 'package:budget_app/models/income.dart';
import 'package:budget_app/service/income_service.dart';
import 'package:flutter/material.dart';

import '../../../injection_container.dart';

class IncomeBalanceWidget extends StatelessWidget {
  final incomeService = sl.get<IncomeService>();

  final Income income;
  final double balance;

  IncomeBalanceWidget({Key key, this.income, this.balance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('income.id${income.id}');
    return Positioned(
      width: 100,
      top: 50,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          (income.amount - balance.floor()).toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
