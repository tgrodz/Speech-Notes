import 'dart:async';
import 'package:speech_notes/db/speech_db.dart';
import 'package:speech_notes/model/note_model.dart';
//https://api.dartlang.org/dev/2.7.0-dev.2.1/dart-async/StreamController-class.html

class NotesBloc {
  //StreamController<T> - allows sending data, error and done events on its stream.
  //broadcast() - controller where stream can be listened to more than once.
  final _clientController = StreamController<List<Note>>.broadcast();

  get notes => _clientController.stream;

  getNotes() async {
    //Add a data to the stream controller using sink which can be listened via the stream
    _clientController.sink.add(await DBProvider.db.getAllNotes());
  }

  NotesBloc() {
    getNotes();
  }

  delete(int id) {
     DBProvider.db.deleteNote(id);
     getNotes();
  }

  add(Note note) async {
   await DBProvider.db.newNote(note);
   await getNotes();
  }

  dispose() {
    _clientController.close();
  }
}
