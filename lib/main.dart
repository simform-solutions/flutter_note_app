import 'package:flutter/material.dart';
import 'Views/home_view.dart';

final routeObserver = RouteObserver<PageRoute>();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        brightness: Brightness.light,
        primarySwatch: Colors.brown,
      ),
      navigatorObservers: [routeObserver],
      home: HomeView(),
    );
  }
}
