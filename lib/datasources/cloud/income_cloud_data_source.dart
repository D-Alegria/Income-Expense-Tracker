import 'package:budget_app/error/exceptions.dart';
import 'package:budget_app/models/income.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IncomeCloudDataSource {
  Future<void> addIncome(Income income);

  Future<List<Income>> getIncomesByUserId(String userId);

  Future<void> updateIncome(Income income);

  Stream<List<Income>> getAllByUserIdStream(String userId);
}

class IncomeCloudDataSourceImpl implements IncomeCloudDataSource {
  final CollectionReference incomeCollection =
      Firestore.instance.collection('income');

  @override
  Future<void> addIncome(Income income) async {
    try{
      await incomeCollection.add(income.toJson());
    }catch(e){
      throw ServerException();
    }
  }

  @override
  Future<List<Income>> getIncomesByUserId(String userId) async {
    print("trying to get user incomes");
      return await incomeCollection
          .where("userId", isEqualTo: userId)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
            print('snapshot.documents${snapshot.documents}');
        return snapshot.documents.map((doc) {
          print('doc.data${doc.data}');
          return Income.fromDoc(doc);
        }).toList();
      });
  }

  @override
  Future<void> updateIncome(Income income)async {
    try{
      await incomeCollection.document(income.id).updateData(income.toJson());
    }catch(e){
      print(e);
    }
  }

  @override
  Stream<List<Income>> getAllByUserIdStream(String userId) {
    return incomeCollection.where("userId",isEqualTo: userId).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        return Income.fromDoc(doc);
      }).toList();
    });
  }
}
