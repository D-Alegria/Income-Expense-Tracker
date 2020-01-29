import 'package:budget_app/error/exceptions.dart';
import 'package:budget_app/models/goal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class GoalCloudDataSource {
  Future<void> addGoal(Goal goal);

  Future<List<Goal>> getGoalsByUserId(String userId);

  Future<void> updateGoal(Goal goal);

  Stream<List<Goal>> getAllByUserIdStream(String userId);
}

class GoalCloudDataSourceImpl implements GoalCloudDataSource {
  final CollectionReference goalCollection =
      Firestore.instance.collection('goal');

  @override
  Future<void> addGoal(Goal goal) async {
    try{
      await goalCollection.add(goal.toJson());
    }catch(e){
      print(e);
      throw ServerException();
    }
  }

  @override
  Future<List<Goal>> getGoalsByUserId(String userId) async {
    print("trying to get user goals");
      return await goalCollection
          .where("userId", isEqualTo: userId)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
            print('snapshot.documents${snapshot.documents}');
        return snapshot.documents.map((doc) {
          print('doc.data${doc.data}');
          return Goal.fromJson(doc.data);
        }).toList();
      });
  }

//  List<Goal> _goalListFromSnapshot(QuerySnapshot snapshot) {
//    return null;
////    try {
////      return snapshot.documents.map((doc) {
////        return GoalModel.fromJson(doc.data);
////      }).toList();
////    } on PlatformException catch (e) {
////      return null;
////    }
//  }

  @override
  Future<void> updateGoal(Goal goal) {
    // TODO: implement updateGoal
    return null;
  }

  @override
  Stream<List<Goal>> getAllByUserIdStream(String userId) {
    return goalCollection.where("userId", isEqualTo: userId).snapshots().map((QuerySnapshot snapshot) {
      print('Stream${snapshot.documents}');
      return snapshot.documents.map((doc) {
        print('Stream1${doc.data}');
        return Goal.fromJson(doc.data);
      }).toList();
    });
  }
}
