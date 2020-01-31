import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Expense extends Equatable {
  final String id;
  final String name;
  final double cost;
  final String income;
  final String userId;
  final String expenseType;
  final DateTime createdAt;

  Expense(
      {this.id,@required this.name,
      @required this.cost,
      @required this.income,
      @required this.userId,
      @required this.expenseType,
      @required this.createdAt})
      : super([id, name, cost, income, userId, expenseType, createdAt]);

  factory Expense.fromDoc(DocumentSnapshot snapshot) {
    Expense expense = Expense.fromJson(snapshot.data);
    return Expense(
        id: snapshot.documentID,
        name: expense.name,
        cost: expense.cost,
        income: expense.income,
        expenseType: expense.expenseType,
        userId: expense.userId,
        createdAt: expense.createdAt);
  }

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
