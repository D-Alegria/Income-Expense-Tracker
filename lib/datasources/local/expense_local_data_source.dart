import 'dart:convert';

import 'package:budget_app/error/exceptions.dart';
import 'package:budget_app/models/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

abstract class ExpenseLocalDataSource {
  Future<List<Expense>> getExpensesByUserId(String userId);

  Future<void> cacheExpensesByUserId(List<Expense> expenseToCache);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final SharedPreferences sharedPreferences;

  ExpenseLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheExpensesByUserId(List<Expense> expenseToCache) {
    // TODO: implement cacheExpenses
    return null;
  }

  @override
  Future<List<Expense>> getExpensesByUserId(userId) {
    final List<String> jsonString = sharedPreferences.getStringList('INCOME_' + userId);
    if(jsonString != null){
      List<Expense> expenseModels = List();
      for (int i = 0; 1 < jsonString.length; i++) {
        expenseModels.add(Expense.fromJson(jsonDecode(jsonString.elementAt(i))));
      }
      return Future.value(expenseModels);
    }else{
      throw CacheException();
    }
  }
}
