import 'dart:convert';

import 'package:budget_app/error/exceptions.dart';
import 'package:budget_app/models/goal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

abstract class GoalLocalDataSource {
  Future<List<Goal>> getGoalsByUserId(String userId);

  Future<void> cacheGoalsByUserId(List<Goal> goalToCache);
}

class GoalLocalDataSourceImpl implements GoalLocalDataSource {
  final SharedPreferences sharedPreferences;

  GoalLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheGoalsByUserId(List<Goal> goalToCache) {
    // TODO: implement cacheGoals
    return null;
  }

  @override
  Future<List<Goal>> getGoalsByUserId(userId) {
    final List<String> jsonString = sharedPreferences.getStringList('INCOME_' + userId);
    if(jsonString != null){
      List<Goal> goalModels = List();
      for (int i = 0; 1 < jsonString.length; i++) {
        goalModels.add(Goal.fromJson(jsonDecode(jsonString.elementAt(i))));
      }
      return Future.value(goalModels);
    }else{
      throw CacheException();
    }
  }
}
