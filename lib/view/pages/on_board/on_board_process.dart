import 'package:budget_app/models/user.dart';
import 'package:budget_app/view/pages/on_board/create_income.dart';
import 'package:budget_app/view/widgets/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnBoardPage extends StatefulWidget {
  @override
  _OnBoardPageState createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  PageController controller = PageController(initialPage: 0,keepPage: true);


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
//    return CreateIncome(next:CreateExpense(next: CreateGoal(next: CreateDebt(next: Wrapper(),),),) ,user: user.uid,);
    return CreateIncome(next: Wrapper(),user: user.uid,);
  }
}
