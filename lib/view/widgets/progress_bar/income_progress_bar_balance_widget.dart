import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/income.dart';
import 'package:budget_app/service/income_service.dart';
import 'package:budget_app/util/decoration/loader.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../injection_container.dart';
import 'linear_progress_bar.dart';

class IncomeLinearProgressBarBalanceWidget extends StatelessWidget {
  final incomeService = sl.get<IncomeService>();

  final Income income;

  IncomeLinearProgressBarBalanceWidget({Key key, this.income})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('income.id${income.id}');
    return FutureBuilder<Either<Failure, double>>(
      future: incomeService.getBalanceById(income.id),
      builder: (BuildContext context,
          AsyncSnapshot<Either<Failure, double>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader();
        } else {
          if (snapshot.data == null)
            return Center(
              child: Text("No result"),
            );
          else
            return snapshot.data
                .fold((ifLeft) => Center(child: Text("No result")), (ifRight) {
              print('income amount${income.amount}');
              print('income used$ifRight');
              print('income% ${((income.amount - ifRight) / income.amount)}');
              return Positioned(
                child: LinearProgressCard(
                  width: 100,
                  progressPercent: ((income.amount - ifRight) / income.amount),
                  thickness: 3,
                ),
                bottom: 5,
              );
            });
        }
      },
    );
  }
}
