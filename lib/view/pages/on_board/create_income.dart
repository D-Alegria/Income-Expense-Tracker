import 'package:budget_app/models/income.dart';
import 'package:budget_app/models/user.dart';
import 'package:budget_app/service/income_service.dart';
import 'package:budget_app/service/onboard.dart';
import 'package:budget_app/util/decoration/button_widget.dart';
import 'package:budget_app/util/decoration/loader.dart';
import 'package:budget_app/view/forms/create_income_form.dart';
import 'package:budget_app/view/widgets/lists/income_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';

class CreateIncome extends StatefulWidget {
  final Widget next;
  final String user;

  const CreateIncome({Key key, this.next, this.user}) : super(key: key);

  @override
  _CreateIncomeState createState() => _CreateIncomeState();
}

class _CreateIncomeState extends State<CreateIncome> {
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
    void _showAddPanel() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: CreateIncomeForm(
                  loader: toggleLoader,
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
              title: Text("Income"),
              centerTitle: true,
            ),
            body: StreamProvider<List<Income>>.value(
                value: incomeService.getAllByUserIdStream(user.uid),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: IncomeList(),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Button(
                          action: () {
                            _showAddPanel();
                          },
                          name: 'Add Income'),
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
//                            print('widget.next${widget.next}');
//                            Navigator.push(context, MaterialPageRoute(builder: (context)=> widget.next));
                          },
                          name: 'Continue'),
                    ),
                  ],
                )));
  }
}
