import 'package:budget_app/models/expense.dart';
import 'package:budget_app/models/income.dart';
import 'package:budget_app/view/widgets/progress_bar/income_balance_widget.dart';
import 'package:budget_app/view/widgets/progress_bar/income_percent_balance_widget.dart';
import 'package:budget_app/view/widgets/progress_bar/income_progress_bar_balance_widget.dart';
import 'package:budget_app/view/widgets/sections/income_description_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncomeCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final incomes = Provider.of<List<Income>>(context) ?? [];
    final expenses = Provider.of<List<Expense>>(context) ?? [];

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IncomeDescriptionProvider()));
                },
                splashColor: Colors.grey,
                child: Text(
                  "manage",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 1.0),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 160.0,
          child: ListView.builder(
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: incomes.length,
            itemBuilder: (BuildContext context, int index) {
              Income income = incomes[index];
              double balance = 0;
              expenses.forEach((expense) {
                if (expense.income == income.id) {
                  balance += expense.cost;
                }
              });
              return Container(
                height: 150,
                padding: EdgeInsets.all(10),
                width: 120,
                margin: EdgeInsets.only(left: 10,right: 10, bottom: 10),
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
                    IncomeBalanceWidget(
                      income: income,
                      balance: balance,
                    ),
                    IncomePercentageBalanceWidget(
                      income: income,
                      balance: balance,
                    ),
                    IncomeLinearProgressBarBalanceWidget(
                      income: income,
                      balance: balance,
                    ),
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
