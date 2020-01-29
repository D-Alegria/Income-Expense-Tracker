import 'package:budget_app/datasources/cloud/expense_cloud_data_source.dart';
import 'package:budget_app/repository/expense_repository_impl.dart';
import 'package:budget_app/repository/goal_repository_impl.dart';
import 'package:budget_app/service/debt_service.dart';
import 'package:budget_app/service/expense_service.dart';
import 'package:budget_app/service/goal_service.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'datasources/cloud/debt_cloud_data_source.dart';
import 'datasources/cloud/goal_cloud_data_source.dart';
import 'datasources/cloud/income_cloud_data_source.dart';
import 'datasources/local/debt_local_data_source.dart';
import 'datasources/local/expense_local_data_source.dart';
import 'datasources/local/goal_local_data_source.dart';
import 'datasources/local/income_local_data_source.dart';
import 'network/network_info.dart';
import 'repository/contracts/debt_repository.dart';
import 'repository/contracts/expense_repository.dart';
import 'repository/contracts/goal_repository.dart';
import 'repository/contracts/income_repository.dart';
import 'repository/debt_repository_impl.dart';
import 'repository/income_repository_impl.dart';
import 'service/income_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //FEATURES
  sl.registerLazySingleton(() => IncomeService(sl()));
  sl.registerLazySingleton(() => ExpenseService(sl()));
  sl.registerLazySingleton(() => GoalService(sl()));
  sl.registerLazySingleton(() => DebtService(sl()));



  //Repository
  //income
  sl.registerLazySingleton<IncomeRepository>(() => IncomeRepositoryImpl(
      networkInfo: sl(), cloudDataSource: sl(), localDataSource: sl(), expenseService: sl()));
  //expense
  sl.registerLazySingleton<ExpenseRepository>(() => ExpenseRepositoryImpl(
      networkInfo: sl(), cloudDataSource: sl(), localDataSource: sl()));
  //goal
  sl.registerLazySingleton<GoalRepository>(() => GoalRepositoryImpl(
      networkInfo: sl(), cloudDataSource: sl(), localDataSource: sl()));
  //debt
  sl.registerLazySingleton<DebtRepository>(() => DebtRepositoryImpl(
      networkInfo: sl(), cloudDataSource: sl(), localDataSource: sl()));

  //DataSources
  //income
  sl.registerLazySingleton<IncomeCloudDataSource>(
      () => IncomeCloudDataSourceImpl());
  sl.registerLazySingleton<IncomeLocalDataSource>(
      () => IncomeLocalDataSourceImpl(sharedPreferences: sl()));
  //expense
  sl.registerLazySingleton<ExpenseCloudDataSource>(
          () => ExpenseCloudDataSourceImpl());
  sl.registerLazySingleton<ExpenseLocalDataSource>(
          () => ExpenseLocalDataSourceImpl(sharedPreferences: sl()));
  //goal
  sl.registerLazySingleton<GoalCloudDataSource>(
          () => GoalCloudDataSourceImpl());
  sl.registerLazySingleton<GoalLocalDataSource>(
          () => GoalLocalDataSourceImpl(sharedPreferences: sl()));
  //debt
  sl.registerLazySingleton<DebtCloudDataSource>(
          () => DebtCloudDataSourceImpl());
  sl.registerLazySingleton<DebtLocalDataSource>(
          () => DebtLocalDataSourceImpl(sharedPreferences: sl()));

  //CORE
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(dataConnectionChecker: sl()));

  //EXTERNAL
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DataConnectionChecker());
}
