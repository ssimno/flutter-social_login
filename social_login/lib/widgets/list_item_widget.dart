import 'package:flutter/material.dart';
import 'package:social_login/models/board_action.dart';
import 'package:social_login/models/board_model.dart';
import 'package:social_login/screens/board_detail_screen.dart';

class BoardListItem extends StatelessWidget {
  final BoardModel boardModelInfo;
  final BoardActions boardActions;
  final VoidCallback returnCallback, addViewsCallback;

  const BoardListItem({
    super.key,
    required this.boardActions,
    required this.boardModelInfo,
    required this.returnCallback,
    required this.addViewsCallback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        addViewsCallback();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (buildContext) => BoardDetailScreen(
              boardActions: boardActions,
              dataInfo: boardModelInfo,
            ),
          ),
        ).then((value) {
          returnCallback();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        height: 80,
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: Colors.black12,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.keyboard_arrow_right_sharp),
                Flexible(
                  child: RichText(
                    maxLines: 2,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(text: boardModelInfo.title),
                        const TextSpan(text: " "),
                        TextSpan(
                          text: "[${boardModelInfo.comments.length}]",
                          style: TextStyle(
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(boardModelInfo.author),
                Text(
                  ' | ${boardModelInfo.getDateTime()} | 추천수 : ${boardModelInfo.likes} 조회수 : ${boardModelInfo.views}',
                  style: const TextStyle(
                    color: Colors.black38,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
