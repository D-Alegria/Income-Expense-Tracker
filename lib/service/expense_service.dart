import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/expense.dart';
import 'package:budget_app/repository/contracts/expense_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ParamsExp extends Equatable {
  final Expense expense;

  ParamsExp({@required this.expense}) : super([expense]);
}

class ExpenseService{
  final ExpenseRepository expenseRepository;

  ExpenseService(this.expenseRepository);

  Future<Either<Failure, void>> create(ParamsExp params) async {
    return await expenseRepository.insert(params.expense);
  }

  Future<Either<Failure, List<Expense>>> getAllByUserId(String userId) async {
    return await expenseRepository.getExpensesByUserId(userId);
  }

  Future<Either<Failure, void>> deleteExpense(String id) async {
    return await expenseRepository.deleteExpense(id);
  }

  Future<Either<Failure, void>> updateExpense(Expense expense) async {
    return await expenseRepository.updateExpense(expense);
  }

  Stream<List<Expense>> getAllByIncomeId(String incomeId) {
    return expenseRepository.getExpensesByIncomeId(incomeId);
  }

  Stream<List<Expense>> getAllByUserIdStream(String userId) {
    return expenseRepository.getAllByUserIdStream(userId);
  }
}