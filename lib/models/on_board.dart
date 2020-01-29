import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class OnBoard extends Equatable {
  final String uid;
  final bool onBoarded;

  OnBoard({@required this.uid, @required this.onBoarded})
      : super([uid, onBoarded]);

  factory OnBoard.fromJson(Map<String, dynamic> jsonMap) {
    return OnBoard(uid: (jsonMap['uid']), onBoarded: (jsonMap['onBoarded']));
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'onBoarded': onBoarded
    };
  }
}
