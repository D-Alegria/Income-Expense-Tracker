import 'package:budget_app/models/income.dart';
import 'package:budget_app/models/user.dart';
import 'package:budget_app/service/income_service.dart';
import 'package:budget_app/view/widgets/sections/income_description_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';

class IncomeDescriptionProvider extends StatelessWidget {
  final incomeService = sl.get<IncomeService>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamProvider<List<Income>>.value(
    value: incomeService.getAllByUserIdStream(user.uid),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 10,
          title: Text("Income Manager"),
          centerTitle: true,
        ),
        body: IncomeDescriptionWidget(),
      ),
    );
  }
}
