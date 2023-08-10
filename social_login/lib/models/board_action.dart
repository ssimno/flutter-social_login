enum BoardType {
  freeBoard,
  noticeBoard,
}

class BoardActions {
  final String title, boardConStr;

  BoardActions({
    required this.title,
    required this.boardConStr,
  });
}
