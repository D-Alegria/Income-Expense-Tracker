import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/goal.dart';
import 'package:dartz/dartz.dart';

abstract class GoalRepository {
  Future<Either<Failure, void>> insert(Goal goal);

  Future<Either<Failure, List<Goal>>> getGoalsByUserId(String userId);

  Stream<List<Goal>> getAllByUserIdStream(String userId);
}
