import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Expense extends Equatable {
  final String name;
  final double cost;
  final String income;
  final String userId;
  final String expenseType;
  final DateTime createdAt;

  Expense(
      {@required this.name,
      @required this.cost,
      @required this.income,
      @required this.userId,
      @required this.expenseType,
      @required this.createdAt})
      : super([name, cost, income, userId, expenseType, createdAt]);

  factory Expense.fromJson(Map<String, dynamic> jsonMap) {
    return Expense(
        name: (jsonMap['name']),
        cost: (jsonMap['cost']),
        income: (jsonMap['income']),
        userId: (jsonMap['userId']),
        expenseType: (jsonMap['expenseType']),
        createdAt: (jsonMap['createdAt'] as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cost': cost,
      'income': income,
      'userId': userId,
      'createdAt': createdAt
    };
  }
}
