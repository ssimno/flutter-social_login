import 'package:flutter/material.dart';
import 'package:social_login/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  Widget getNavScreen() {
    switch (_selectedIndex) {
      case 0: // 홈
        {
          return const Text('111');
        }
      case 1: // 내 정보
        {
          return Center(
            child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('로그아웃'),
                        content: const Text('로그아웃을 하시겠습니까?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('아니요'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('예'),
                            onPressed: () {
                              //로그아웃 로직 처리
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (buildContext) =>
                                      const LoginScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.logout_outlined,
                )),
          );
        }
      default:
        {
          return const Text('333');
        }
    }
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
      body: getNavScreen(),
      drawer: Drawer(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const SizedBox(
                  height: 100,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text('Drawer Header'),
                  ),
                ),
                ListTile(
                  title: const Text('Item 1'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Item 2'),
                  onTap: () {
                    Navigator.pop(context);
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
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}
