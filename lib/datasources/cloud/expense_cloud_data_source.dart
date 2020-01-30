import 'package:budget_app/error/exceptions.dart';
import 'package:budget_app/models/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ExpenseCloudDataSource {
  Future<void> addExpense(Expense expense);

  Future<List<Expense>> getExpensesByUserId(String userId);

  Stream<List<Expense>> getExpensesByIncomeId(String incomeId);

  Future<void> updateExpense(Expense expense);

  Stream<List<Expense>> getAllByUserIdStream(String userId);
}

class ExpenseCloudDataSourceImpl implements ExpenseCloudDataSource {
  final CollectionReference expenseCollection =
      Firestore.instance.collection('expense');

  @override
  Future<void> addExpense(Expense expense) async {
    try {
      await expenseCollection.add(expense.toJson());
    } catch (e) {
      print(e);
      throw ServerException();
    }
  }

  @override
  Future<List<Expense>> getExpensesByUserId(String userId) async {
    print("trying to get user expenses");
    return await expenseCollection
        .where("userId", isEqualTo: userId)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      print('snapshot.documents${snapshot.documents}');
      return snapshot.documents.map((doc) {
        print('doc.data${doc.data}');
        return Expense.fromJson(doc.data);
      }).toList();
    });
  }

  @override
  Future<void> updateExpense(Expense expense) {
    // TODO: implement updateExpense
    return null;
  }

  @override
  Stream<List<Expense>> getAllByUserIdStream(String userId) {
    return expenseCollection
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      print('Stream${snapshot.documents}');
      return snapshot.documents.map((doc) {
        print('Stream1${doc.data}');
        return Expense.fromJson(doc.data);
      }).toList();
    });
  }

  @override
  Stream<List<Expense>> getExpensesByIncomeId(String incomeId) {
    return expenseCollection
        .where("income", isEqualTo: incomeId)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      print('snapshot.documents${snapshot.documents}');
      return snapshot.documents.map((doc) {
        print('doc.data${doc.data}');
        return Expense.fromJson(doc.data);
      }).toList();
    });
  }
}
