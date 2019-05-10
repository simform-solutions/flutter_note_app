import 'package:flutter/material.dart';
import 'package:notes_app/Classes/note.dart';

class AddNote extends StatelessWidget {
  final Note note;
  AddNote({this.note});
  @override
  Widget build(BuildContext context) {
    String title = 'Add Note';
    List<Widget> icons;
    TextEditingController _titleControllor;
    TextEditingController _noteControllor;
    if (note != null) {
      icons = [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {},
        ),
      ];
      title = 'View Note';
      _titleControllor = TextEditingController(
        text: note.title,
      );
      _noteControllor = TextEditingController(text: note.note);
    }
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
              enabled: note == null ? true : false,
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
              enabled: note == null ? true : false,
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
              child: note == null
                  ? RawMaterialButton(
                      fillColor: Colors.brown,
                      shape: StadiumBorder(),
                      onPressed: () {},
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
