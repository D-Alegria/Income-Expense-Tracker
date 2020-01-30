import 'package:budget_app/models/income.dart';
import 'package:budget_app/models/user.dart';
import 'package:budget_app/service/income_service.dart';
import 'package:budget_app/util/decoration/loader.dart';
import 'package:budget_app/view/forms/create_income_form.dart';
import 'package:budget_app/view/widgets/sections/income_description_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';

class IncomeDescriptionProvider extends StatefulWidget {
  @override
  _IncomeDescriptionProviderState createState() =>
      _IncomeDescriptionProviderState();
}

class _IncomeDescriptionProviderState extends State<IncomeDescriptionProvider> {
  final incomeService = sl.get<IncomeService>();
  bool loading = false;

  void toggleLoader() {
    setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

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
        },
      );
    }

    return loading
        ? Loader()
        : StreamProvider<List<Income>>.value(
            value: incomeService.getAllByUserIdStream(user.uid),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 10,
                title: Text("Income Manager"),
                centerTitle: true,
                actions: <Widget>[
                  FlatButton.icon(
                      icon: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      splashColor: Colors.grey,
                      label: Text(
                        "Add income",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      onPressed: () {
                        _showAddPanel();
                      })
                ],
              ),
              body: IncomeDescriptionWidget(
                loader: toggleLoader,
              ),
            ),
          );
  }
}
