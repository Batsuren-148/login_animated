import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:login_animated/screen/home.dart';
import 'package:login_animated/screen/profile.dart';

class RouterPage extends StatefulWidget {
  const RouterPage({super.key});

  @override
  State<RouterPage> createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  int _page = 0;

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _totalPage = [
    const HomePage(),
    const HomePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _totalPage[_page],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        backgroundColor: Colors.transparent,
        color: Colors.deepPurple,
        height: 65,
        animationCurve: Curves.easeIn,
        items: const [
          Icon(
            Icons.home,
            color: Colors.white,
            size: 30,
          ),
          Icon(
            Icons.add_circle_outline_rounded,
            color: Colors.white,
            size: 30,
          ),
          Icon(
            Icons.person,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    );
  }
}
