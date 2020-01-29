import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/expense.dart';
import 'package:budget_app/models/income.dart';
import 'package:budget_app/models/user.dart';
import 'package:budget_app/service/expense_service.dart';
import 'package:budget_app/service/income_service.dart';
import 'package:budget_app/util/decoration/button_widget.dart';
import 'package:budget_app/util/decoration/loader.dart';
import 'package:budget_app/view/forms/create_expense_form.dart';
import 'package:budget_app/view/widgets/lists/expense_list.dart';
import 'package:dartz/dartz.dart' as dar;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';

class CreateExpense extends StatefulWidget {
  final Widget next;

  const CreateExpense({Key key, this.next}) : super(key: key);

  @override
  _CreateExpenseState createState() => _CreateExpenseState();
}

class _CreateExpenseState extends State<CreateExpense> {
  final expenseService = sl.get<ExpenseService>();
  final incomeService = sl.get<IncomeService>();
  bool loading = false;

  void toggleLoader() {
    setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          });
    }

    final user = Provider.of<User>(context);
    return loading
        ? Loader()
        : Scaffold(
            resizeToAvoidBottomPadding: true,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 10,
              title: Text("Expense"),
              centerTitle: true,
            ),
            body: StreamProvider<List<Expense>>.value(
                value: expenseService.getAllByUserIdStream(user.uid),
//                catchError: ,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ExpenseList(),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Button(
                          action: () async {
                            dar.Either<Failure, List<Income>> incomes =
                                await incomeService.getAllByUserId(user.uid);
                            incomes.fold((ifLeft) {print('ifLeft$ifLeft');}, (ifRight) {_showAddPanel(ifRight);});
                          },
                          name: 'Add Expense'),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Button(
                          action: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => widget.next));
                          },
                          name: 'Continue'),
                    ),
                  ],
                )));
  }
}
