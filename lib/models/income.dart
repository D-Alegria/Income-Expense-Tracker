import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Income extends Equatable {
  final String id;
  final String name;
  final double amount;
  final String userId;
  final DateTime createdAt;

  Income(
      {this.id,
      @required this.name,
      @required this.amount,
      @required this.userId,
      @required this.createdAt})
      : super([id, name, amount, userId, createdAt]);

  factory Income.fromDoc(DocumentSnapshot snapshot) {
    Income income = Income.fromJson(snapshot.data);
    return Income(
        id: snapshot.documentID,
        name: income.name,
        amount: income.amount,
        userId: income.userId,
        createdAt: income.createdAt);
  }

  factory Income.fromJson(Map<String, dynamic> jsonMap) {
    return Income(
        name: (jsonMap['name']),
        amount: (jsonMap['amount']),
        userId: (jsonMap['userId']),
        createdAt: (jsonMap['createdAt'] as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'userId': userId,
      'createdAt': createdAt
    };
  }
}
