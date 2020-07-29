import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/routes.dart';
import 'package:flutter_sandbox/screens/app_review.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xFFFFFFFF,
          const <int, Color>{
            50: const Color(0xFFFFFFFF),
            100: const Color(0xFFFFFFFF),
            200: const Color(0xFFFFFFFF),
            300: const Color(0xFFFFFFFF),
            400: const Color(0xFFFFFFFF),
            500: const Color(0xFFFFFFFF),
            600: const Color(0xFFFFFFFF),
            700: const Color(0xFFFFFFFF),
            800: const Color(0xFFFFFFFF),
            900: const Color(0xFFFFFFFF),
          },
        ),
      ),
      routes: routes,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);
  static final routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _children = [AppReviewScreen()];

  int _currentIndex = 0;

  _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.touch_app), title: Text('app_review')),
          ]),
    );
  }
}
