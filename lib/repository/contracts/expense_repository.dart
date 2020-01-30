import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/expense.dart';
import 'package:dartz/dartz.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, void>> insert(Expense expense);

  Future<Either<Failure, List<Expense>>> getExpensesByUserId(String userId);

  Stream<List<Expense>> getExpensesByIncomeId(String incomeId);

  Stream<List<Expense>> getAllByUserIdStream(String userId);
}
