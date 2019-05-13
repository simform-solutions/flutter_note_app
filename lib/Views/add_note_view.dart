import 'package:flutter/material.dart';
import 'package:notes_app/Classes/note.dart';
import 'package:notes_app/Utils/db_halper.dart';

class AddNote extends StatefulWidget {
  final Note note;
  AddNote({this.note});
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  bool _isEditiable = true;
  String title = 'Add Note';
  List<Widget> icons;
  TextEditingController _titleControllor;
  TextEditingController _noteControllor;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseHelper helper = DatabaseHelper();

  @override
  void initState() {
    _titleControllor = TextEditingController();
    _noteControllor = TextEditingController();
    _setData();
    super.initState();
  }

  @override
  void dispose() {
    _titleControllor.dispose();
    _noteControllor.dispose();
    super.dispose();
  }

  _setData() {
    if (widget.note != null) {
      _isEditiable = false;
      icons = [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            setState(() {
              _isEditiable = !_isEditiable;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _deleteNote();
          },
        ),
      ];
      title = 'View Note';
      _titleControllor = TextEditingController(
        text: widget.note.title,
      );
      _noteControllor = TextEditingController(text: widget.note.note);
    }
  }

  _deleteNote() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure, you want to Delete This Note?'),
            actions: <Widget>[
              RawMaterialButton(
                onPressed: () {
                  helper.deleteNote(widget.note.id);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Yes'),
              ),
              RawMaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'),
              ),
            ],
          );
        });
  }

  _showSnakbar(String msg) {
    final snackbar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.brown,
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  bool _checkNotNull() {
    bool res;
    if (_titleControllor.text.isEmpty && _noteControllor.text.isEmpty) {
      _showSnakbar('Title and Note cannot be empty');
      res = false;
    } else if (_noteControllor.text.isEmpty) {
      _showSnakbar('Note cannot be empty');
      res = false;
    } else if (_titleControllor.text.isEmpty) {
      _showSnakbar('Title cannot be empty');
      res = false;
    } else {
      res = true;
    }
    return res;
  }

  _saveNote() {
    if (_checkNotNull() == true) {
      if (widget.note != null) {
        widget.note.title = _titleControllor.text;
        widget.note.note = _noteControllor.text;
        helper.updateNote(widget.note);
      } else {
        Note note =
            Note(title: _titleControllor.text, note: _noteControllor.text);
        helper.insertNote(note);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        actions: icons,
        title: Text(title),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            TextField(
              enabled: _isEditiable ? true : false,
              controller: _titleControllor,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                  hintText: 'Title'),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              enabled: _isEditiable ? true : false,
              controller: _noteControllor,
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Note',
                  hintText: 'Note'),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: _isEditiable
                  ? RawMaterialButton(
                      fillColor: Theme.of(context).accentColor,
                      shape: StadiumBorder(),
                      onPressed: () {
                        _saveNote();
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }
}
