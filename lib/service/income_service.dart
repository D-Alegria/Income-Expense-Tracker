import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/income.dart';
import 'package:budget_app/repository/contracts/income_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Params extends Equatable {
  final Income income;

  Params({@required this.income}) : super([income]);
}

class IncomeService{
  final IncomeRepository incomeRepository;

  IncomeService(this.incomeRepository);

  Future<Either<Failure, void>> create(Params params) async {
    return await incomeRepository.insert(params.income);
  }

  Future<Either<Failure, List<Income>>> getAllByUserId(String userId) async {
    return await incomeRepository.getIncomesByUserId(userId);
  }

  Future<Either<Failure, void>> deleteIncome(String id) async {
    return await incomeRepository.deleteIncome(id);
  }

  Future<Either<Failure, void>> updateIncome(Income income) async {
    return await incomeRepository.updateIncome(income);
  }

  Stream<List<Income>> getAllByUserIdStream(String userId) {
    return incomeRepository.getAllByUserIdStream(userId);
  }
}