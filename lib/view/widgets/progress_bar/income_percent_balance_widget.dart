import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/income.dart';
import 'package:budget_app/service/income_service.dart';
import 'package:budget_app/util/decoration/loader.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../injection_container.dart';
import 'linear_progress_bar.dart';

class IncomePercentageBalanceWidget extends StatelessWidget {
  final incomeService = sl.get<IncomeService>();

  final Income income;
  final double balance;

  IncomePercentageBalanceWidget({Key key, this.income,this.balance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('income.id${income.id}');
//    return FutureBuilder<Either<Failure, double>>(
//      future: incomeService.getBalanceById(income.id),
//      builder: (BuildContext context,
//          AsyncSnapshot<Either<Failure, double>> snapshot) {
//        if (snapshot.connectionState == ConnectionState.waiting) {
//          return Loader();
//        } else {
//          if (snapshot.data == null)
//            return Center(
//              child: Text("No result"),
//            );
//          else
//            return snapshot.data
//                .fold((ifLeft) => Center(child: Text("No result")), (ifRight) {
//              print('income amount${income.amount}');
//              print('income used$ifRight');
//              print('income% ${((income.amount - ifRight) / income.amount)}');
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
//            });
//        }
//      },
//    );
  }
}
