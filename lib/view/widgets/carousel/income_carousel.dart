import 'package:budget_app/models/income.dart';
import 'package:budget_app/view/widgets/progress_bar/income_balance_widget.dart';
import 'package:budget_app/view/widgets/progress_bar/income_percent_balance_widget.dart';
import 'package:budget_app/view/widgets/progress_bar/income_progress_bar_balance_widget.dart';
import 'package:budget_app/view/widgets/progress_bar/linear_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncomeCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final incomes = Provider.of<List<Income>>(context) ?? [];

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Text(
                  "manage",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 1.0),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 170.0,
          child: ListView.builder(
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: incomes.length,
            itemBuilder: (BuildContext context, int index) {
              Income income = incomes[index];
              return Container(
                height: 150,
                padding: EdgeInsets.all(10),
                width: 120,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.44),
                        blurRadius: 6,
                        offset: Offset(3, 3))
                  ],
                ),
                child: Stack(
//                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      income.name,
                      style: TextStyle(fontSize: 12),
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    IncomeBalanceWidget(income: income,),
                    IncomePercentageBalanceWidget(income: income,),
                    IncomeLinearProgressBarBalanceWidget(income: income,),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
