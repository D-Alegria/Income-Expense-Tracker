import 'package:budget_app/datasources/cloud/income_cloud_data_source.dart';
import 'package:budget_app/datasources/local/income_local_data_source.dart';
import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/expense.dart';
import 'package:budget_app/models/income.dart';
import 'package:budget_app/network/network_info.dart';
import 'package:budget_app/error/exceptions.dart';
import 'package:budget_app/service/expense_service.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import 'contracts/income_repository.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final NetworkInfo networkInfo;
  final IncomeCloudDataSource cloudDataSource;
  final IncomeLocalDataSource localDataSource;
  final ExpenseService expenseService;

  IncomeRepositoryImpl({
    @required this.networkInfo,
    @required this.cloudDataSource,
    @required this.localDataSource,
    @required this.expenseService,
  });

  @override
  Future<Either<Failure, List<Income>>> getIncomesByUserId(
      String userId) async {
    print("Im here");
    if (await networkInfo.isConnected) {
      try {
        final incomes = await cloudDataSource.getIncomesByUserId(userId);
        print('incomes$incomes');
        localDataSource.cacheIncomesByUserId(incomes);
        return Right(incomes);
      } on ServerException {
        print("server");
        return Left(ServerFailure());
      } catch (e) {
        print(e);
        return Left(ServerFailure());
      }
    } else {
      try {
        final localIncomes = await localDataSource.getIncomesByUserId(userId);
        return Right(localIncomes);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> insert(Income income) async {
    if (await networkInfo.isConnected) {
      try {
        final newIncome = await cloudDataSource.addIncome(income);
        return Right(newIncome);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      print("No connection");
      return Left(ServerFailure());
    }
  }

  @override
  Stream<List<Income>> getAllByUserIdStream(String userId) {
    final incomes = cloudDataSource.getAllByUserIdStream(userId);
    print('incomes$incomes');
//        localDataSource.cacheIncomesByUserId(incomes);
    return incomes;
//    } on ServerException {
//      print("server");
////        return Left(ServerFailure());
//    } catch (e) {
//      print(e);
////        return Left(ServerFailure());
//    }
  }

  @override
  Stream<double> getBalanceById(String id) {
//    try {
//      final expenses = expenseService.getAllByIncomeId(id);
//      double amount = 0;
//
//
//        expenses.forEach((expense) {
//          amount += expense.cost;
//        });
//      }

//      expenses.fold((ifLeft) => Left(ServerFailure()), (ifRight) {
//
//      });
//      return Right(amount);
//    } on ServerException {
//      return Left(ServerFailure());
//    }
  }
}
