import 'package:budget_app/models/income.dart';
import 'package:budget_app/service/income_service.dart';
import 'package:flutter/material.dart';

import '../../../injection_container.dart';
import 'linear_progress_bar.dart';

class IncomeLinearProgressBarBalanceWidget extends StatelessWidget {
  final incomeService = sl.get<IncomeService>();

  final Income income;
  final double balance;

  IncomeLinearProgressBarBalanceWidget({Key key, this.income,this.balance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('income.id${income.id}');
              return Positioned(
                child: LinearProgressCard(
                  width: 100,
                  progressPercent: ((income.amount - balance) / income.amount),
                  thickness: 3,
                ),
                bottom: 5,
              );
//            });
//        }
//      },
//    );
  }
}
