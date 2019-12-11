import 'dart:convert';

Note noteFromJson(String str) {
  final jsonData =  json.decode(str);
  return Note.fromMap(jsonData);
}

String noteToJson(Note data) {
  return json.encode(data.toMap());
}

class Note {
  int id;
  String txt;

  Note({this.id,this.txt});
  Note.entry(this.txt);

  factory Note.fromMap(Map<String, dynamic> json) => new Note(
    id: json["id"],
    txt: json["txt"],
  );

  Map<String ,dynamic> toMap() => {
    "id": id,
    "txt": txt,
  };

}