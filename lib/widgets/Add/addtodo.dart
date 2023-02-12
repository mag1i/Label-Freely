import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:labelfreely/todo.dart';

import '../../database/repository.dart';

class addtodo extends StatefulWidget {
  const addtodo({Key? key}) : super(key: key);

  @override
  State<addtodo> createState() => _addtodoState();
}

class _addtodoState extends State<addtodo> {
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Color pickerColor = const Color(0xff2196f3);
  Color currentColor = const Color(0xff443a49);
  Future colorPickerDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0)),
                padding: const EdgeInsets.only(
                    left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
  Todo td= Todo();
  var _textFieldController = TextEditingController();
  Repository rep= new Repository();
  @override
  Widget build(BuildContext context) {
    var color =
    pickerColor.toString().replaceAll(RegExp(r'(?:_|[^\w\s])+'), '');
    var rSpaceColor = color.replaceAll(RegExp(r'(\s)'), '');

    var rcolorText = rSpaceColor.toLowerCase().replaceAll(
        RegExp(r'color'), '');

    var materialPrimaryvalue = 'materialprimaryvalue'.toLowerCase();
    var replaceWith = '';
    var colorCode = rcolorText.replaceAll(materialPrimaryvalue, replaceWith);

    int colorCodeInt = num.tryParse(colorCode) as int;
    Color selectedColor = Color(colorCodeInt);


        var g=pickerColor;
        return AlertDialog(
          title: const Text('Add a new todo item'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your new todo'),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: g,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  padding: const EdgeInsets.only(
                      left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
              onPressed: (() {
                colorPickerDialog();
              }),
              child: const Text('PICK COLOR'),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {

                Todo td =Todo();
                 //  setState(() async {
                td.name=_textFieldController.text;
                td.checked=0;
                //td.colr=colorCodeInt;

                rep.insertData("Todos", td.todoMap());
                Navigator.of(context).pop();
                // });


                //_addTodoItem(_textFieldController.text);

              },
            ),
          ],
        );
      }
  }

