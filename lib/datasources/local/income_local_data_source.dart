import 'dart:convert';

import 'package:budget_app/error/exceptions.dart';
import 'package:budget_app/models/income.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

abstract class IncomeLocalDataSource {
  Future<List<Income>> getIncomesByUserId(String userId);

  Future<void> cacheIncomesByUserId(List<Income> incomeToCache);
}

class IncomeLocalDataSourceImpl implements IncomeLocalDataSource {
  final SharedPreferences sharedPreferences;

  IncomeLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheIncomesByUserId(List<Income> incomeToCache) {
    // TODO: implement cacheIncomes
    return null;
  }

  @override
  Future<List<Income>> getIncomesByUserId(userId) {
    final List<String> jsonString = sharedPreferences.getStringList('INCOME_' + userId);
    if(jsonString != null){
      List<Income> incomeModels = List();
      for (int i = 0; 1 < jsonString.length; i++) {
        incomeModels.add(Income.fromJson(jsonDecode(jsonString.elementAt(i))));
      }
      return Future.value(incomeModels);
    }else{
      throw CacheException();
    }
  }
}
