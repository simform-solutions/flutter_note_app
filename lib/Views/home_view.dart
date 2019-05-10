import 'package:flutter/material.dart';
import 'package:notes_app/Utils/db_halper.dart';
import 'package:notes_app/Views/add_note_view.dart';

class HomeView extends StatelessWidget {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    databaseHelper.initlizeDatabase();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share),
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
                    if(snapshot.data.length != 1){
                      return Center(child: Text('No Notes, Create New one'),);
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
                            Divider(color: Colors.brown)
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
