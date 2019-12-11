import 'package:flutter/material.dart';

import '../block/notess_block.dart';
import 'details_page.dart';
import '../model/note_model.dart';

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(title: 'Note List', home:  NoteList());
  }
}

class NoteList extends StatefulWidget {
  @override
  createState() =>  NoteListState();
}

class NoteListState extends State<NoteList> {
  Stream<int> myStream;
  var _bloc = NotesBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("--NoteApp build");
    Scaffold scaffold =  Scaffold(
      appBar:  AppBar(title:  Text('Note List')),
      body: StreamBuilder<List<Note>>(
        stream: _bloc.notes,
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
          if (snapshot.hasData) {

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Note item = snapshot.data[index];

                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    _promptRemoveNoteItem(item);
                  },
                  child: ListTile(
                    title: Text(item.txt),
                    leading: Text(item.id.toString()),
                    trailing: Icon(
                      Icons.swap_horiz,
                      color: Colors.green,
                      size: 30.0,
                    ),
                  ),
                );
              },
            );

          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton:  FloatingActionButton(
        tooltip: 'Add note',
        child: Icon(Icons.add),
        onPressed: () {
          _pushAddNoteDetailsScreen();
        },
      ),
    );
    WillPopScope willPopScope = WillPopScope(child: scaffold,onWillPop:_handleBack);

    return willPopScope;
  }

  Future<bool> _handleBack() {
    print("-- NoteApp  back button action");
    return Future<bool>.value(false);
  }

  void _pushAddNoteDetailsScreen() {
    navigateToSubPage(context);
  }

  Future navigateToSubPage(context) async {
    Note note = Note();
    note = await Navigator.push(context, MaterialPageRoute(builder: (context) => Details()));
    _addNoteItem(note);
  }

  void _addNoteItem(Note note) {
    if (note != null) {
      _bloc.add(note);
    }
  }

  void _removeNoteItem(Note item) {
    setState(() =>  _bloc.delete(item.id));
  }

  void _promptRemoveNoteItem(Note item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return  AlertDialog(title:  Text(' "${item.txt}" '), actions: <Widget>[
            FlatButton(
                child:  Text('Cancel'),
                // The alert is actually part of the navigation stack,
                // so to close it, need to pop it.
               onPressed: () => setState(() =>  Navigator.of(context).pop() )
            ),
             FlatButton(
                child:  Text('Remove?'),
                onPressed: () {
                  _removeNoteItem(item);
                  Navigator.of(context).pop();
                })
          ]);
        });
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }


}

