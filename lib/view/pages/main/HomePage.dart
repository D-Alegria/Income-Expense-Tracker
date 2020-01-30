import 'package:budget_app/models/expense.dart';
import 'package:budget_app/models/income.dart';
import 'package:budget_app/models/user.dart';
import 'package:budget_app/service/expense_service.dart';
import 'package:budget_app/util/decoration/button_widget.dart';
import 'package:budget_app/util/decoration/loader.dart';
import 'package:budget_app/view/forms/create_expense_form.dart';
import 'package:budget_app/view/widgets/carousel/income_carousel.dart';
import 'package:budget_app/view/widgets/sections/expense_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final expenseService = sl.get<ExpenseService>();
  bool loading = false;

  void toggleLoader() {
    setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final incomes = Provider.of<List<Income>>(context) ?? [];

    void _showAddPanel(List<Income> incomes) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: CreateExpenseForm(
                loader: toggleLoader,
                incomes: incomes,
              ),
            ),
          );
        },
      );
    }

    return loading
        ? Loader()
        : StreamProvider<List<Expense>>.value(
            value: expenseService.getAllByUserIdStream(user.uid),
            child: Scaffold(
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 22, top: 25),
                      child: RichText(
                        text: TextSpan(
                          text: 'welcome',
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' ',
                            ),
                            TextSpan(
                              text: user.name ?? 'User',
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IncomeCarousel(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Button(
                        action: () async {
                          _showAddPanel(incomes);
                        },
                        name: "Add Expense",
                      ),
                    ),
                    Expanded(
                      child: ExpenseSection(),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
