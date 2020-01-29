import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/goal.dart';
import 'package:budget_app/models/income.dart';
import 'package:budget_app/models/user.dart';
import 'package:budget_app/service/goal_service.dart';
import 'package:budget_app/service/income_service.dart';
import 'package:budget_app/util/decoration/button_widget.dart';
import 'package:budget_app/util/decoration/loader.dart';
import 'package:budget_app/view/forms/create_goal_form.dart';
import 'package:budget_app/view/widgets/lists/goal_list.dart';
import 'package:dartz/dartz.dart' as dar;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';

class CreateGoal extends StatefulWidget {
  final Widget next;

  const CreateGoal({Key key, this.next}) : super(key: key);

  @override
  _CreateGoalState createState() => _CreateGoalState();
}

class _CreateGoalState extends State<CreateGoal> {
  final goalService = sl.get<GoalService>();
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
                child: CreateGoalForm(
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
              title: Text("Goal"),
              centerTitle: true,
            ),
            body: StreamProvider<List<Goal>>.value(
                value: goalService.getAllByUserIdStream(user.uid),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: GoalList(),
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
                          name: 'Add Goal'),
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
