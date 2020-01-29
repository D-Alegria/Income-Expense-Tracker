import 'package:budget_app/datasources/cloud/goal_cloud_data_source.dart';
import 'package:budget_app/datasources/local/goal_local_data_source.dart';
import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/goal.dart';
import 'package:budget_app/network/network_info.dart';
import 'package:budget_app/error/exceptions.dart';
import 'package:budget_app/repository/contracts/goal_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';


class GoalRepositoryImpl implements GoalRepository {
  final NetworkInfo networkInfo;
  final GoalCloudDataSource cloudDataSource;
  final GoalLocalDataSource localDataSource;

  GoalRepositoryImpl(
      {@required this.networkInfo,
      @required this.cloudDataSource,
      @required this.localDataSource});

  @override
  Future<Either<Failure, List<Goal>>> getGoalsByUserId(
      String userId) async {
    print("Im here");
    if (await networkInfo.isConnected) {
      try {
        final goals = await cloudDataSource.getGoalsByUserId(userId);
        print('incomes$goals');
        localDataSource.cacheGoalsByUserId(goals);
        return Right(goals);
      } on ServerException {
        print("server");
        return Left(ServerFailure());
      } catch (e) {
        print(e);
        return Left(ServerFailure());
      }
    } else {
      try {
        final localGoals = await localDataSource.getGoalsByUserId(userId);
        return Right(localGoals);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> insert(Goal income) async {
    if (await networkInfo.isConnected) {
      try {
        final newGoal = await cloudDataSource.addGoal(income);
        return Right(newGoal);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      print("No connection");
      return Left(ServerFailure());
    }
  }

  @override
  Stream<List<Goal>> getAllByUserIdStream(String userId) {
    final incomes = cloudDataSource.getAllByUserIdStream(userId);
//    print('incomes$incomes');
//        localDataSource.cacheGoalsByUserId(incomes);
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
