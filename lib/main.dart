import 'package:flutter/material.dart';
import 'Utils/theme_bloc.dart';
import 'Views/home_view.dart';
import 'Classes/theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

final routeObserver = RouteObserver<PageRoute>();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getTheme(),
      builder: (builder, snapshot) {
        if (snapshot.data == null) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Loading'),
              ),
            ),
          );
        } else {
          return StreamBuilder(
            stream: bloc.darkThemeEnabled,
            initialData: snapshot.data,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return MaterialApp(
                  home: Scaffold(
                    body: Center(
                      child: Text('Loading Data'),
                    ),
                  ),
                );
              } else {
                return MaterialApp(
                  title: 'Notes App',
                  theme: snapshot.data ? Themes.light : Themes.dark,
                  navigatorObservers: [routeObserver],
                  home: HomeView(snapshot.data),
                );
              }
            },
          );
        }
      },
    );
  }

  _getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool val = prefs.getBool('darkTheme');
    print(val);
    return val;
  }
}
