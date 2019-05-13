import 'dart:async';

class Bloc{
  final _themeControllor = StreamController<bool>();
  get changeTheme => _themeControllor.sink.add;
  get darkThemeEnabled => _themeControllor.stream;

  dispose(){
    _themeControllor.close();
  }
}

final bloc = Bloc();