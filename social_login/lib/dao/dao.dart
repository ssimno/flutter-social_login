import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:social_login/models/board_model.dart';

class Boards {
  String path = 'boards';
  String views = 'views';
  String comments = 'comments';
  String date = 'date';

  String base() => path;

  String freeBoard() => '$path/freeBoard';

  String noticeBoard() => '$path/noticeBoard';
}

class ConnectionString {
  static Boards boards() => Boards();
}

class DAO {
  //////////////////
  /// CREATE
  /////////////////

  // 게시글 생성
  static Future createBoard({
    required String title,
    required String author,
    required String content,
    required String paramStr,
  }) {
    final databaseReference = FirebaseDatabase.instance.ref();
    return databaseReference.child(paramStr).push().set(
          BoardModel(
            boardId: "",
            uid: FirebaseAuth.instance.currentUser?.uid ?? "",
            author: author,
            timestamp: 0,
            title: title,
            likes: 0,
            content: content,
            comments: [],
            views: 0,
          ).toJson(),
        );
  }

  static Future<void> createComment({
    required String boardId,
    required String conStr,
    required Comment comment,
  }) async {
    final DatabaseReference commentRef = FirebaseDatabase.instance
        .ref("$conStr/$boardId/${ConnectionString.boards().comments}");

    DataSnapshot snapshot = await commentRef.get();

    if (snapshot.value == null) {
      return commentRef.set([comment.toJson()]);
    } else {
      List<dynamic> currentComments =
          List<dynamic>.from(snapshot.value as List<dynamic>);
      currentComments.add(comment.toJson());
      return commentRef.set(currentComments);
    }
  }

  //////////////////
  /// READ
  /////////////////

  static Future<DataSnapshot> readBoard(String paramStr) {
    return FirebaseDatabase.instance.ref().child(paramStr).get();
  }

  static Future<List<BoardModel>> readBoardWithModel(String paramStr) async {
    DataSnapshot data = await readBoard(paramStr);
    if (data.value == null) {
      return []; // 데이터가 없으면 빈 리스트를 반환
    }
    Map<dynamic, dynamic> values = data.value as Map<dynamic, dynamic>;

    List<BoardModel> result = [];

    for (var key in values.keys) {
      BoardModel item = BoardModel.fromJson(values[key], key);
      result.add(item);
    }
    return result;
  }

  static Future<BoardModel> readBoardDetail({
    required String conStr,
    required String boardId,
  }) async {
    DataSnapshot snapshot =
        await FirebaseDatabase.instance.ref("$conStr/$boardId").get();

    BoardModel item = BoardModel.fromJson(snapshot.value, boardId);
    return item;
  }

  //////////////////
  /// UPDATE
  /////////////////
  static void updateBoardViews({
    required String id,
    required String conStr,
  }) async {
    DatabaseReference postRef = FirebaseDatabase.instance
        .ref("$conStr/$id")
        .child(ConnectionString.boards().views);

    postRef.runTransaction((Object? post) {
      dynamic post2;

      // post가 null일 경우 초기값 설정
      if (post == null) {
        post2 = 1;
      } else {
        post2 = post as dynamic;
        if (post2 != null) {
          post2 += 1;
        } else {
          post2 = post2 ?? 1;
        }
      }
      return Transaction.success(post2);
    });
  }

  //////////////////
  /// DELETE
  /////////////////

  static Future removeBoard({
    required String boardId,
    required String conStr,
  }) =>
      FirebaseDatabase.instance.ref().child("$conStr/$boardId").remove();
}
