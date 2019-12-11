import 'package:flutter/material.dart';
import 'pages/notes_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Note List',
        home:  NoteList(),
    );
  }
}
