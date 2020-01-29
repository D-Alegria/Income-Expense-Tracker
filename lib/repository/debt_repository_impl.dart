import 'package:budget_app/datasources/cloud/debt_cloud_data_source.dart';
import 'package:budget_app/datasources/local/debt_local_data_source.dart';
import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/debt.dart';
import 'package:budget_app/network/network_info.dart';
import 'package:budget_app/error/exceptions.dart';
import 'package:budget_app/repository/contracts/debt_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';


class DebtRepositoryImpl implements DebtRepository {
  final NetworkInfo networkInfo;
  final DebtCloudDataSource cloudDataSource;
  final DebtLocalDataSource localDataSource;

  DebtRepositoryImpl(
      {@required this.networkInfo,
      @required this.cloudDataSource,
      @required this.localDataSource});

  @override
  Future<Either<Failure, List<Debt>>> getDebtsByUserId(
      String userId) async {
    print("Im here");
    if (await networkInfo.isConnected) {
      try {
        final debts = await cloudDataSource.getDebtsByUserId(userId);
        print('incomes$debts');
        localDataSource.cacheDebtsByUserId(debts);
        return Right(debts);
      } on ServerException {
        print("server");
        return Left(ServerFailure());
      } catch (e) {
        print(e);
        return Left(ServerFailure());
      }
    } else {
      try {
        final localDebts = await localDataSource.getDebtsByUserId(userId);
        return Right(localDebts);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> insert(Debt income) async {
    if (await networkInfo.isConnected) {
      try {
        final newDebt = await cloudDataSource.addDebt(income);
        return Right(newDebt);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      print("No connection");
      return Left(ServerFailure());
    }
  }

  @override
  Stream<List<Debt>> getAllByUserIdStream(String userId) {
    final incomes = cloudDataSource.getAllByUserIdStream(userId);
//    print('incomes$incomes');
//        localDataSource.cacheDebtsByUserId(incomes);
    return incomes;
//    } on ServerException {
//      print("server");
////        return Left(ServerFailure());
//    } catch (e) {
//      print(e);
////        return Left(ServerFailure());
//    }
  }
}
