import 'package:budget_app/datasources/cloud/expense_cloud_data_source.dart';
import 'package:budget_app/datasources/local/expense_local_data_source.dart';
import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/expense.dart';
import 'package:budget_app/network/network_info.dart';
import 'package:budget_app/error/exceptions.dart';
import 'package:budget_app/repository/contracts/expense_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final NetworkInfo networkInfo;
  final ExpenseCloudDataSource cloudDataSource;
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl(
      {@required this.networkInfo,
      @required this.cloudDataSource,
      @required this.localDataSource});

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByUserId(
      String userId) async {
    print("Im here");
    if (await networkInfo.isConnected) {
      try {
        final expenses = await cloudDataSource.getExpensesByUserId(userId);
        print('incomes$expenses');
        localDataSource.cacheExpensesByUserId(expenses);
        return Right(expenses);
      } on ServerException {
        print("server");
        return Left(ServerFailure());
      } catch (e) {
        print(e);
        return Left(ServerFailure());
      }
    } else {
      try {
        final localExpenses = await localDataSource.getExpensesByUserId(userId);
        return Right(localExpenses);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> insert(Expense income) async {
    if (await networkInfo.isConnected) {
      try {
        final newExpense = await cloudDataSource.addExpense(income);
        return Right(newExpense);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      print("No connection");
      return Left(ServerFailure());
    }
  }

  @override
  Stream<List<Expense>> getAllByUserIdStream(String userId) {
    try {
      final incomes = cloudDataSource.getAllByUserIdStream(userId);
      print('incomes$incomes');
      return incomes;
    } catch (e) {
      print('Stream$e');
      throw ServerException();
    }
  }

  @override
  Stream<List<Expense>> getExpensesByIncomeId(String incomeId) {
    print("Im here");
    final expenses = cloudDataSource.getExpensesByIncomeId(incomeId);
    print('incomes$expenses');
    return expenses;
  }

  @override
  Future<Either<Failure, void>> deleteExpense(String id) async{
    if (await networkInfo.isConnected) {
      try {
        final newExpense = await cloudDataSource.deleteExpense(id);
        return Right(newExpense);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      print("No connection");
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateExpense(Expense expense) async {
    if (await networkInfo.isConnected) {
      try {
        print("Conbetero");
        final newExpense = await cloudDataSource.updateExpense(expense);
        return Right(newExpense);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      print("No connection");
      return Left(ServerFailure());
    }
  }
}
