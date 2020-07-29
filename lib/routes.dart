import 'package:flutter/material.dart';
import 'package:flutter_sandbox/main.dart';

Map<String, Widget Function(BuildContext context)> routes = {
  HomeScreen.routeName: (context) => HomeScreen(),
};
