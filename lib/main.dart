import 'package:flutter/material.dart';
import 'package:flutter_sandbox/routes.dart';
import 'package:flutter_sandbox/screens/app_review.dart';
import 'package:flutter_sandbox/screens/rate_my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      theme: ThemeData(primarySwatch: Colors.blue),
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
  final List<Widget> _children = [AppReviewScreen(), RateMyAppScreen()];

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
            BottomNavigationBarItem(
                icon: Icon(Icons.touch_app), title: Text('rate_my_app')),
          ]),
    );
  }
}
