import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/goal.dart';
import 'package:budget_app/repository/contracts/goal_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ParamsExp extends Equatable {
  final Goal goal;

  ParamsExp({@required this.goal}) : super([goal]);
}

class GoalService{
  final GoalRepository goalRepository;

  GoalService(this.goalRepository);

  Future<Either<Failure, void>> create(ParamsExp params) async {
    return await goalRepository.insert(params.goal);
  }

  Future<Either<Failure, List<Goal>>> getAllByUserId(String userId) async {
    return await goalRepository.getGoalsByUserId(userId);
  }

  Stream<List<Goal>> getAllByUserIdStream(String userId) {
    return goalRepository.getAllByUserIdStream(userId);
  }
}