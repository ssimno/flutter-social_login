import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_login/dao/dao.dart';
import 'package:social_login/models/board_model.dart';
import 'package:social_login/utilities/common_utility.dart';
import 'package:social_login/widgets/list_item_widget.dart';

import '../models/board_action.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  BoardType boardType = BoardType.freeBoard;
  bool _showFloatingButton = true;

  final Map<BoardType, BoardActions> boardActionMap = {
    BoardType.freeBoard: BoardActions(
      title: "자유게시판",
      boardConStr: ConnectionString.boards().freeBoard(),
    ),
    BoardType.noticeBoard: BoardActions(
      title: "공지사항",
      boardConStr: ConnectionString.boards().noticeBoard(),
    ),
  };

  Widget getNavScreen() {
    switch (_selectedIndex) {
      case 0: // 홈
        {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerLeft,
                height: 60,
                child: Text(
                  boardActionMap[boardType]!.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              FutureBuilder(
                  future: DAO.readBoardWithModel(
                      boardActionMap[boardType]!.boardConStr),
                  builder:
                      (buildContext, AsyncSnapshot<List<BoardModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.hasData) {
                        List<BoardModel>? dataList = snapshot.data;
                        List<BoardListItem> boards = [];

                        dataList?.sort(
                            (a, b) => b.timestamp.compareTo(a.timestamp));

                        dataList?.forEach((element) {
                          boards.add(BoardListItem(
                            boardActions: boardActionMap[boardType]!,
                            boardModelInfo: element,
                            returnCallback: () {
                              setState(() {});
                            },
                            addViewsCallback: () {
                              DAO.updateBoardViews(
                                id: element.boardId,
                                conStr: boardActionMap[boardType]!.boardConStr,
                              );
                            },
                          ));
                        });

                        return Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 0,
                            ),
                            itemCount: boards.length,
                            itemBuilder: (context, index) {
                              return boards[index];
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 0,
                              );
                            },
                          ),
                        );
                      }
                    }
                    return const SizedBox(
                      width: 1.0, // 원하는 너비
                      height: 1.0, // 원하는 높이
                      child: CircularProgressIndicator(),
                    ); // 데이터를 기다리는 동안 로딩 표시
                  })
            ],
          );
        }
      case 1: // 내 정보
        {
          return Column(
            children: [
              Expanded(
                  child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black12,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(2, 2),
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white12,
                            ),
                            child: FittedBox(
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: FirebaseAuth
                                            .instance.currentUser?.photoURL !=
                                        null
                                    ? Image.network(FirebaseAuth
                                            .instance.currentUser?.photoURL ??
                                        "")
                                    : const Icon(Icons.person),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            FirebaseAuth.instance.currentUser?.displayName ??
                                "익명",
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    makeMyInfoItemPanel(
                      onTap: () {
                        CommonUtilities.showMessageBox(
                          context: context,
                          content: "준비중입니다.",
                          okBtn: () {},
                          okStr: "확인",
                        );
                      },
                      color: Colors.black,
                      content: "작성글 보기",
                    ),
                    makeMyInfoItemPanel(
                      onTap: () {
                        CommonUtilities.showMessageBox(
                          context: context,
                          content: "준비중입니다.",
                          okBtn: () {},
                          okStr: "확인",
                        );
                      },
                      color: Colors.black,
                      content: "환경설정",
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    makeMyInfoItemPanel(
                      onTap: () {
                        CommonUtilities.showMessageBox(
                          title: "로그아웃",
                          context: context,
                          content: "로그아웃을 하시겠습니까?",
                          okBtn: () {
                            FirebaseAuth.instance.signOut().then((value) {
                              //로그아웃 로직 처리
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (buildContext) =>
                                      const LoginScreen(),
                                ),
                              );
                            });
                          },
                          okStr: "로그아웃",
                          okColor: Colors.red.shade300,
                          cancelBtn: () {},
                          cancelStr: "아니요",
                        );
                      },
                      color: Colors.red.shade300,
                      content: "로그아웃",
                    ),
                  ],
                ),
              )),
            ],
          );
        }
      default:
        {
          return const Text('333');
        }
    }
  }

  // 내 정보 아이템 패널 생성
  InkWell makeMyInfoItemPanel({
    required VoidCallback onTap,
    required Color color,
    required String content,
  }) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 1,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            const Icon(Icons.keyboard_arrow_right_outlined)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Builder(
        builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu_outlined),
          );
        },
      )),
      floatingActionButton: _showFloatingButton
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (buildContext) {
                      final titleController = TextEditingController();
                      final contentController = TextEditingController();

                      return AlertDialog(
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (contentController.text.isEmpty ||
                                  titleController.text.isEmpty) {
                                showDialog(
                                    context: context,
                                    builder: (builderContext2) {
                                      return AlertDialog(
                                        content: const Text("제목과 내용을 기입해 주세요."),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("확인"),
                                          ),
                                        ],
                                      );
                                    });
                              } else {
                                Navigator.pop(context);
                                setState(() {
                                  DAO
                                      .createBoard(
                                    title: titleController.text,
                                    author: FirebaseAuth.instance.currentUser
                                            ?.displayName ??
                                        "익명",
                                    content: contentController.text,
                                    paramStr:
                                        boardActionMap[boardType]!.boardConStr,
                                  )
                                      .then((value) {
                                    // 작성성공
                                  }).catchError((onError) {
                                    // 작성실패
                                  });
                                });
                              }
                            },
                            child: const Text('작성완료'),
                          ),
                        ],
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              boardActionMap[boardType]!.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              height: 1,
                              color: Colors.black26,
                            ),
                            Row(
                              children: [
                                const Text('제목: '),
                                Expanded(
                                  child: TextField(
                                    controller: titleController,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text('내용: '),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: contentController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      );
                    });
              },
              backgroundColor: Colors.red.shade400,
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            )
          : null,
      body: getNavScreen(),
      drawer: Drawer(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(
                  height: 100,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white12,
                          ),
                          child: FittedBox(
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon:
                                  FirebaseAuth.instance.currentUser?.photoURL !=
                                          null
                                      ? Image.network(FirebaseAuth
                                              .instance.currentUser?.photoURL ??
                                          "")
                                      : const Icon(Icons.person),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          FirebaseAuth.instance.currentUser?.displayName ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('공지사항'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      boardType = BoardType.noticeBoard;
                      _selectedIndex = 0;
                    });
                  },
                ),
                const DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: Colors.black54,
                  dashRadius: 0.0,
                  dashGapLength: 4.0,
                  dashGapColor: Colors.transparent,
                  dashGapRadius: 0.0,
                ),
                ListTile(
                  title: const Text('자유게시판'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      boardType = BoardType.freeBoard;
                      _selectedIndex = 0;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내 정보',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _showFloatingButton = value == 0;
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}
