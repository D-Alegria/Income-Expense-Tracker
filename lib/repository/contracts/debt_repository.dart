import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/debt.dart';
import 'package:dartz/dartz.dart';

abstract class DebtRepository {
  Future<Either<Failure, void>> insert(Debt debt);

  Future<Either<Failure, List<Debt>>> getDebtsByUserId(String userId);

  Stream<List<Debt>> getAllByUserIdStream(String userId);
}
