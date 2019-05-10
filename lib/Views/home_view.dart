import 'package:flutter/material.dart';
import 'package:notes_app/Classes/data.dart';
import 'package:notes_app/Classes/note.dart';
// import 'package:notes_app/CustomWidgets/custom_card.dart';
import 'package:notes_app/Views/add_note_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Note> data = getData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            // Container(
            //   padding: EdgeInsets.only(left: 10),
            //   child: Text(
            //     'Notes',
            //     style: TextStyle(fontSize: 35.0),
            //   ),
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.882,
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int i) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(data[i].title),
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => AddNote(
                                    note: data[i],
                                  ));
                          Navigator.push(context, route);
                        },
                      ),
                      Divider(color: Colors.brown)
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF4e342e),
        onPressed: () {
          Route route = MaterialPageRoute(builder: (context) => AddNote());
          Navigator.push(context, route);
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
