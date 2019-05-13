import 'package:flutter/material.dart';
import 'Utils/theme_bloc.dart';
import 'Views/home_view.dart';
import 'Classes/theme_data.dart';

final routeObserver = RouteObserver<PageRoute>();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.darkThemeEnabled,
      initialData: false,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Notes App',
          theme: snapshot.data ? Themes.light : Themes.dark,
          navigatorObservers: [routeObserver],
          home: HomeView(snapshot.data),
        );
      },
    );
  }
}
