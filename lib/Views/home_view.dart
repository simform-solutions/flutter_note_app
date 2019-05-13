import 'package:flutter/material.dart';
import 'package:notes_app/Utils/db_halper.dart';
import 'package:notes_app/Utils/theme_bloc.dart';
import 'package:notes_app/Views/add_note_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

final routeObserver = RouteObserver<PageRoute>();
final duration = const Duration(milliseconds: 300);

class HomeView extends StatefulWidget {
  final bool darkThemeEnabled;
  HomeView(this.darkThemeEnabled);
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with RouteAware {
  GlobalKey _fabKey = GlobalKey();
  String _themeType;

  @override
  void initState() {
    if (!widget.darkThemeEnabled) {
      _themeType = 'Light Theme';
    } else {
      _themeType = 'Dark Theme';
    }
    super.initState();
  }

  final DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  _setPref(bool res) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkTheme', res);
  }

  @override
  Widget build(BuildContext context) {
    databaseHelper.initlizeDatabase();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share),
          ),
          PopupMenuButton<bool>(
            onSelected: (res) {
              bloc.changeTheme(res);
              _setPref(res);
              setState(() {
                if (_themeType == 'Dark Theme') {
                  _themeType = 'Light Theme';
                } else {
                  _themeType = 'Dark Theme';
                }
              });
            },
            itemBuilder: (context) {
              return <PopupMenuEntry<bool>>[
                PopupMenuItem<bool>(
                  value: !widget.darkThemeEnabled,
                  child: Text(_themeType),
                )
              ];
            },
          )
        ],
        title: Text('Notes'),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.882,
              child: FutureBuilder(
                future: databaseHelper.getNoteList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Text('Loading');
                  } else {
                    if (snapshot.data.length < 1) {
                      return Center(
                        child: Text('No Notes, Create New one'),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(snapshot.data[i].title),
                              onTap: () {
                                Route route = MaterialPageRoute(
                                    builder: (context) => AddNote(
                                          note: snapshot.data[i],
                                        ));
                                Navigator.push(context, route);
                              },
                            ),
                            Divider(color: Theme.of(context).accentColor)
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: _buildFAB(context, key: _fabKey),
    );
  }

  Widget _buildFAB(context, {key}) => FloatingActionButton(
        elevation: 0,
        key: key,
        onPressed: () => _onFabTap(context),
        child: Icon(Icons.add),
      );

  _onFabTap(BuildContext context) {
    final RenderBox fabRenderBox = _fabKey.currentContext.findRenderObject();
    final fabSize = fabRenderBox.size;
    final fabOffset = fabRenderBox.localToGlobal(Offset.zero);

    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          AddNote(),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) =>
          _buildTransition(child, animation, fabSize, fabOffset),
    ));
  }

  Widget _buildTransition(
    Widget page,
    Animation<double> animation,
    Size fabSize,
    Offset fabOffset,
  ) {
    if (animation.value == 1) return page;

    final borderTween = BorderRadiusTween(
      begin: BorderRadius.circular(fabSize.width / 2),
      end: BorderRadius.circular(0.0),
    );
    final sizeTween = SizeTween(
      begin: fabSize,
      end: MediaQuery.of(context).size,
    );
    final offsetTween = Tween<Offset>(
      begin: fabOffset,
      end: Offset.zero,
    );

    final easeInAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
    );
    final easeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    );

    final radius = borderTween.evaluate(easeInAnimation);
    final offset = offsetTween.evaluate(animation);
    final size = sizeTween.evaluate(easeInAnimation);

    final transitionFab = Opacity(
      opacity: 1 - easeAnimation.value,
      child: _buildFAB(context),
    );

    Widget positionedClippedChild(Widget child) => Positioned(
        width: size.width,
        height: size.height,
        left: offset.dx,
        top: offset.dy,
        child: ClipRRect(
          borderRadius: radius,
          child: child,
        ));

    return Stack(
      children: [
        positionedClippedChild(page),
        positionedClippedChild(transitionFab),
      ],
    );
  }
}
