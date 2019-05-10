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
          onPressed: () {},
        ),
      ];
      title = 'View Note';
      _titleControllor = TextEditingController(
        text: widget.note.title,
      );
      print(widget.note.title);
      _noteControllor = TextEditingController(text: widget.note.note);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: icons,
        title: Text(title),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            // Container(
            //   padding: EdgeInsets.only(left: 10),
            //   child: Text(
            //     'Add Notes',
            //     style: TextStyle(fontSize: 35.0),
            //   ),
            // ),
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
                      fillColor: Colors.brown,
                      shape: StadiumBorder(),
                      onPressed: () {
                        // print(_titleControllor.text);
                        // print(_noteControllor.text);
                        Note note = Note(
                            title: _titleControllor.text,
                            note: _noteControllor.text);
                        helper.insertNote(note);
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
