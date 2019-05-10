import 'note.dart';

List<Note> getData(){
  List<Note> data = List<Note>();
  data.add(Note(title:'Buy Fruits',note: 'Buy Mango'));
  data.add(Note(title:'Wash car',note: 'Wash car'));
  data.add(Note(title:'Wash Bike',note: 'Wash Bike'));
  data.add(Note(title:'Buy Books',note: 'Buy books'));
  data.add(Note(title:'Buy Mouse',note: 'Mouse'));
  data.add(Note(title:'Keyboard',note: 'Keyboard')); 
  return data;
}