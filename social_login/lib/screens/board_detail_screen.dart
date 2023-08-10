import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_login/dao/dao.dart';
import 'package:social_login/models/board_action.dart';
import 'package:social_login/models/board_model.dart';
import 'package:social_login/utilities/common_utility.dart';

class BoardDetailScreen extends StatefulWidget {
  final BoardModel dataInfo;
  final BoardActions boardActions;

  const BoardDetailScreen({
    super.key,
    required this.boardActions,
    required this.dataInfo,
  });

  @override
  State<BoardDetailScreen> createState() => _BoardDetailScreenState();
}

class _BoardDetailScreenState extends State<BoardDetailScreen> {
  Future<BoardModel>? _boardDetailFuture;
  final TextEditingController commentController = TextEditingController();
  ValueKey<int> _futureBuilderKey = const ValueKey<int>(0);

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    _boardDetailFuture = DAO.readBoardDetail(
      boardId: widget.dataInfo.boardId,
      conStr: widget.boardActions.boardConStr,
    );
    _futureBuilderKey = ValueKey<int>(_futureBuilderKey.value + 1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: SingleChildScrollView(
                child: FutureBuilder(
                  key: _futureBuilderKey,
                  future: _boardDetailFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntrinsicWidth(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  widget.boardActions.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  snapshot.data!.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                        '${snapshot.data!.author} | ${snapshot.data!.getDateTime()}'),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    if (widget.dataInfo.uid ==
                                        FirebaseAuth.instance.currentUser!.uid)
                                      TextButton(
                                        onPressed: () {
                                          CommonUtilities.showMessageBox(
                                            context: context,
                                            title: "게시물 삭제",
                                            content: '정말로 삭제하시겠습니까?',
                                            okBtn: () {
                                              DAO
                                                  .removeBoard(
                                                boardId:
                                                    widget.dataInfo.boardId,
                                                conStr: widget
                                                    .boardActions.boardConStr,
                                              )
                                                  .then((value) {
                                                Navigator.pop(context);
                                              });
                                            },
                                            okColor: Colors.red.shade300,
                                            okStr: '삭제',
                                            cancelBtn: () {},
                                            cancelStr: '취소',
                                          );
                                        },
                                        child: Text(
                                          '삭제',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.red.shade300,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                            child: Divider(
                              height: 2,
                            ),
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: 230,
                              maxHeight: double.infinity,
                            ),
                            child: Column(
                              children: [
                                Text(snapshot.data!.content),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                            child: Divider(
                              height: 2,
                            ),
                          ),
                          Column(children: [
                            for (var item in snapshot.data!.comments)
                              makeCommentItem(
                                item.author,
                                item.content,
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextField(
                                    controller: commentController,
                                  )),
                                  const SizedBox(
                                    width: 9,
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      if (commentController.text.isNotEmpty) {
                                        await DAO.createComment(
                                          boardId: widget.dataInfo.boardId,
                                          conStr:
                                              widget.boardActions.boardConStr,
                                          comment: Comment(
                                            author: FirebaseAuth.instance
                                                    .currentUser?.displayName ??
                                                "익명",
                                            content: commentController.text,
                                          ),
                                        );

                                        commentController.clear();
                                        FocusScope.of(context).unfocus();

                                        _refreshData();
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.send,
                                      color: Colors.blue,
                                      size: 24,
                                    ),
                                  )
                                  // TextButton(
                                  //   child: const Text('쓰기'),
                                  //   onPressed: () {},
                                  // ),
                                ],
                              ),
                            )
                          ])
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container makeCommentItem(String author, String content) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      color: Colors.transparent,
      height: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            author,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 13,
          ),
          const DottedLine(
            direction: Axis.horizontal,
            lineLength: double.infinity,
            lineThickness: 1.0,
            dashLength: 3.0,
            dashColor: Colors.black12,
            dashRadius: 0.0,
            dashGapLength: 4.0,
            dashGapColor: Colors.transparent,
            dashGapRadius: 0.0,
          ),
        ],
      ),
    );
  }
}
