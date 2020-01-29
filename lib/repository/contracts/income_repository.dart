import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/income.dart';
import 'package:dartz/dartz.dart';

abstract class IncomeRepository {
  Future<Either<Failure, void>> insert(Income income);

  Future<Either<Failure, List<Income>>> getIncomesByUserId(String userId);

  Future<Either<Failure, double>> getBalanceById(String id);

  Stream<List<Income>> getAllByUserIdStream(String userId);
}
