import 'package:budget_app/error/exceptions.dart';
import 'package:budget_app/models/debt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DebtCloudDataSource {
  Future<void> addDebt(Debt debt);

  Future<List<Debt>> getDebtsByUserId(String userId);

  Future<void> updateDebt(Debt debt);

  Stream<List<Debt>> getAllByUserIdStream(String userId);
}

class DebtCloudDataSourceImpl implements DebtCloudDataSource {
  final CollectionReference debtCollection =
      Firestore.instance.collection('debt');

  @override
  Future<void> addDebt(Debt debt) async {
    try{
      await debtCollection.add(debt.toJson());
    }catch(e){
      print(e);
      throw ServerException();
    }
  }

  @override
  Future<List<Debt>> getDebtsByUserId(String userId) async {
    print("trying to get user debts");
      return await debtCollection
          .where("userId", isEqualTo: userId)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
            print('snapshot.documents${snapshot.documents}');
        return snapshot.documents.map((doc) {
          print('doc.data${doc.data}');
          return Debt.fromJson(doc.data);
        }).toList();
      });
  }

//  List<Debt> _debtListFromSnapshot(QuerySnapshot snapshot) {
//    return null;
////    try {
////      return snapshot.documents.map((doc) {
////        return DebtModel.fromJson(doc.data);
////      }).toList();
////    } on PlatformException catch (e) {
////      return null;
////    }
//  }

  @override
  Future<void> updateDebt(Debt debt) {
    // TODO: implement updateDebt
    return null;
  }

  @override
  Stream<List<Debt>> getAllByUserIdStream(String userId) {
    return debtCollection.where("userid").snapshots().map((QuerySnapshot snapshot) {
      print('Stream${snapshot.documents}');
      return snapshot.documents.map((doc) {
        print('Stream1${doc.data}');
        return Debt.fromJson(doc.data);
      }).toList();
    });
  }
}
