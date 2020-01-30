import 'package:budget_app/models/income.dart';
import 'package:budget_app/service/income_service.dart';
import 'package:flutter/material.dart';

import '../../../injection_container.dart';

class IncomePercentageBalanceWidget extends StatelessWidget {
  final incomeService = sl.get<IncomeService>();

  final Income income;
  final double balance;

  IncomePercentageBalanceWidget({Key key, this.income, this.balance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('income.id${income.id}');
    return Positioned(
      bottom: 20,
      width: 100,
      child: Align(
        alignment: Alignment.center,
        child: Text(
            '${(((income.amount - balance) / income.amount) * 100).floor().toString()}% remaining',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            )),
      ),
    );
  }
}
