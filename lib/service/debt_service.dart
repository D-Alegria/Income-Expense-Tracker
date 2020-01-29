import 'package:budget_app/error/error.dart';
import 'package:budget_app/models/debt.dart';
import 'package:budget_app/repository/contracts/debt_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ParamsExp extends Equatable {
  final Debt debt;

  ParamsExp({@required this.debt}) : super([debt]);
}

class DebtService{
  final DebtRepository debtRepository;

  DebtService(this.debtRepository);

  Future<Either<Failure, void>> create(ParamsExp params) async {
    return await debtRepository.insert(params.debt);
  }

  Future<Either<Failure, List<Debt>>> getAllByUserId(String userId) async {
    return await debtRepository.getDebtsByUserId(userId);
  }

  Stream<List<Debt>> getAllByUserIdStream(String userId) {
    return debtRepository.getAllByUserIdStream(userId);
  }
}