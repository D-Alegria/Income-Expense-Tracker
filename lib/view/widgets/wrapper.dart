import 'package:budget_app/models/on_board.dart';
import 'package:budget_app/models/user.dart';
import 'package:budget_app/service/onboard.dart';
import 'package:budget_app/util/decoration/loader.dart';
import 'package:budget_app/view/pages/MainApp.dart';
import 'package:budget_app/view/pages/on_board/on_board_process.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final OnBoardService onBoardService = OnBoardService();

    if (user == null) {
      return Authenticate();
    } else {
      return FutureBuilder<List<OnBoard>>(
          future: onBoardService.getOnBoardStatus(user.uid),
          builder:
              (BuildContext context, AsyncSnapshot<List<OnBoard>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loader();
            } else {
              if (snapshot.data == null)
                return Authenticate();
              else
                return snapshot.data.first.onBoarded
                    ? MainApp()
                    : OnBoardPage();
            }
          });
    }
  }
}