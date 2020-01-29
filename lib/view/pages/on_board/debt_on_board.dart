import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/debt.dart';
import 'package:budget_app/models/income.dart';
import 'package:budget_app/models/user.dart';
import 'package:budget_app/service/debt_service.dart';
import 'package:budget_app/service/income_service.dart';
import 'package:budget_app/service/onboard.dart';
import 'package:budget_app/util/decoration/button_widget.dart';
import 'package:budget_app/util/decoration/loader.dart';
import 'package:budget_app/view/forms/create_debt_form.dart';
import 'package:budget_app/view/widgets/lists/debt_list.dart';
import 'package:dartz/dartz.dart' as dar;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';

class CreateDebt extends StatefulWidget {
  final Widget next;

  const CreateDebt({Key key, this.next}) : super(key: key);

  @override
  _CreateDebtState createState() => _CreateDebtState();
}

class _CreateDebtState extends State<CreateDebt> {
  final debtService = sl.get<DebtService>();
  final incomeService = sl.get<IncomeService>();
  final OnBoardService onBoardService = OnBoardService();

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
                child: CreateDebtForm(
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
              title: Text("Debt"),
              centerTitle: true,
            ),
            body: StreamProvider<List<Debt>>.value(
                value: debtService.getAllByUserIdStream(user.uid),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: DebtList(),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Button(
                          action: () async {

//                            print('income$income');
                            dar.Either<Failure, List<Income>> incomes =
                                await incomeService.getAllByUserId(user.uid);
                            incomes.fold((ifLeft) {print('ifLeft$ifLeft');}, (ifRight) {_showAddPanel(ifRight);});
                          },
                          name: 'Add Debt'),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Button(
                          action: () async {
                            await onBoardService.updateOnBoardStatus(user.uid);
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
