import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Debt extends Equatable {
  final String name;
  final double amount;
  final String income;
  final String userId;
  final DateTime createdAt;

  Debt({@required this.name,
    @required this.amount,
    @required this.income,
    @required this.userId,
    @required this.createdAt})
      : super([name, amount, income, userId, createdAt]);


  factory Debt.fromJson(Map<String, dynamic> jsonMap) {
    return Debt(
        name: (jsonMap['name']),
        amount: (jsonMap['amount']),
        income: (jsonMap['income']),
        userId: (jsonMap['userId']),
        createdAt: (jsonMap['createdAt'] as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'income': income,
      'userId': userId,
      'createdAt': createdAt
    };
  }
}