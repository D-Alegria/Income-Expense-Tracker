import 'package:budget_app/models/on_board.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnBoardService {
  final CollectionReference _onBoardCollection =
      Firestore.instance.collection('onboard');

  Future addBoarding(OnBoard onBoard) async {
    try {
      return await _onBoardCollection
          .document(onBoard.uid)
          .setData(onBoard.toJson());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<OnBoard>> getOnBoardStatus(String userId) async {
    try {
      return await _onBoardCollection.where("uid",isEqualTo: userId).getDocuments().then((snapshots) {
        print('get ${snapshots.documents.first.data}');
        return snapshots.documents.map((doc){
          print('qwert${doc.data}');
          return OnBoard.fromJson(doc.data);
        }).toList();
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updateOnBoardStatus(String userId) async {
    try {
      await _onBoardCollection.document(userId).updateData(OnBoard(uid: userId, onBoarded: true).toJson());
    } catch (e) {
      print(e);
      return null;
    }
  }
}
