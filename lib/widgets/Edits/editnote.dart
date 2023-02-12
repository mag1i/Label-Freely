import 'package:flutter/material.dart';



const c1 = 0xFFFDFFFC, c2 = 0xFFFF595E, c3 = 0xFF374B4A, c4 = 0xFF00B1CC, c5 = 0xFFFFD65C, c6 = 0xFFB9CACA,
    c7 = 0x80374B4A;

class NotesEdit extends StatefulWidget {
  _NotesEdit createState() => _NotesEdit();
}

class _NotesEdit extends State<NotesEdit> {
  String noteTitle = '';
  String noteContent = '';
  String noteColor = 'red';

  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _contentTextController = TextEditingController();

  void handleTitleTextChange() {
    setState(() {
      noteTitle = _titleTextController.text.trim();
    });
  }

  void handleNoteTextChange() {
    setState(() {
      noteContent = _contentTextController.text.trim();
    });
  }

  @override
  void initState() {
    super.initState();
    _titleTextController.addListener(handleTitleTextChange);
    _contentTextController.addListener(handleNoteTextChange);
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _contentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0),
      appBar: AppBar(
        backgroundColor: const Color(0),

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color:  Color(c1),
          ),
          tooltip: 'Back',
          onPressed: () => {},
        ),

        //title: NoteTitleEntry(_titleTextController),
      ),

    //  body: NoteEntry(_contentTextController),
    );
  }
}