import 'package:budget_app/datasources/cloud/income_cloud_data_source.dart';
import 'package:budget_app/datasources/local/income_local_data_source.dart';
import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/income.dart';
import 'package:budget_app/network/network_info.dart';
import 'package:budget_app/error/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import 'contracts/income_repository.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final NetworkInfo networkInfo;
  final IncomeCloudDataSource cloudDataSource;
  final IncomeLocalDataSource localDataSource;

  IncomeRepositoryImpl({
    @required this.networkInfo,
    @required this.cloudDataSource,
    @required this.localDataSource,
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
    return incomes;

  }

  @override
  Future<Either<Failure, void>> updateIncome(Income income) async {
    if (await networkInfo.isConnected) {
      try {
        final newIncome = await cloudDataSource.updateIncome(income);
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
  Future<Either<Failure, void>> deleteIncome(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final newIncome = await cloudDataSource.deleteIncome(id);
        return Right(newIncome);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      print("No connection");
      return Left(ServerFailure());
    }
  }
}
