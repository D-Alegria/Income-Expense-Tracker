import 'package:budget_app/models/income.dart';
import 'package:budget_app/models/user.dart';
import 'package:budget_app/service/income_service.dart';
import 'package:budget_app/view/pages/main/HomePage.dart';
import 'package:budget_app/view/pages/main/goal_page.dart';
import 'package:budget_app/view/pages/main/savings_page.dart';
import 'package:budget_app/view/pages/main/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../injection_container.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final incomeService = sl.get<IncomeService>();
  int _currentIndex = 0;
  PageController controller = PageController(initialPage: 0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamProvider<List<Income>>.value(
      value: incomeService.getAllByUserIdStream(user.uid),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.black26,
                ),
                title: Text("")),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.show_chart,
                  color: Colors.black26,
                ),
                title: Text("")),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_balance_wallet,
                  color: Colors.black26,
                ),
                title: Text("Savings")),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.credit_card,
                  color: Colors.black26,
                ),
                title: Text("Goals")),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                color: Colors.black26,
              ),
              title: Text("Account"),
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
              controller.animateToPage(index,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            });
          },
        ),
        body: SafeArea(
            child: PageView(
          onPageChanged: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          controller: controller,
          children: <Widget>[
            HomePage(),
            SavingsPage(),
            GoalPage(),
//                StatisticsPage(),
//                SavingsPage(),
//                GoalPage(),
            ProfilePage(),
          ],
        )),
      ),
    );
//    }
  }
}
