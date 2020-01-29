import 'dart:convert';

import 'package:budget_app/error/exceptions.dart';
import 'package:budget_app/models/debt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

abstract class DebtLocalDataSource {
  Future<List<Debt>> getDebtsByUserId(String userId);

  Future<void> cacheDebtsByUserId(List<Debt> debtToCache);
}

class DebtLocalDataSourceImpl implements DebtLocalDataSource {
  final SharedPreferences sharedPreferences;

  DebtLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheDebtsByUserId(List<Debt> debtToCache) {
    // TODO: implement cacheDebts
    return null;
  }

  @override
  Future<List<Debt>> getDebtsByUserId(userId) {
    final List<String> jsonString = sharedPreferences.getStringList('INCOME_' + userId);
    if(jsonString != null){
      List<Debt> debtModels = List();
      for (int i = 0; 1 < jsonString.length; i++) {
        debtModels.add(Debt.fromJson(jsonDecode(jsonString.elementAt(i))));
      }
      return Future.value(debtModels);
    }else{
      throw CacheException();
    }
  }
}
