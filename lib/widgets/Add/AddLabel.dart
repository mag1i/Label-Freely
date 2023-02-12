import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:labelfreely/database/servicescnt.dart';

import '../../Models/Category.dart';
import '../../database/repository.dart';


class Label{
  int? idc;
  String? namec;
  int? colorlbl;


  lblMap() {
    var mapping = Map<String, dynamic>();
    mapping['idlabel'] = idc ?? null;
    mapping['namelabel'] = namec!;
    mapping['colorlabel'] = colorlbl ?? null;

    return mapping;
  }  }
class Addlabel extends StatefulWidget {
  Addlabel({ Key? key}) : super(key: key);

  @override
  _AddlabelPageState createState() => _AddlabelPageState();
}

class _AddlabelPageState extends State<Addlabel> {
  final _categoryController = TextEditingController();
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  UserService categoryOperations = UserService();
  Color pickerColor = const Color(0xff2196f3);
  //Color currentColor = const Color(0xff443a49);

  @override
  Widget build(BuildContext context) {

    var color =
    pickerColor.toString().replaceAll(RegExp(r'(?:_|[^\w\s])+'), '');
    var rSpaceColor = color.replaceAll(RegExp(r'(\s)'), '');

    var rcolorText = rSpaceColor.toLowerCase().replaceAll(RegExp(r'color'), '');

    var materialPrimaryvalue = 'materialprimaryvalue'.toLowerCase();
    var replaceWith = '';
    var colorCode = rcolorText.replaceAll(materialPrimaryvalue, replaceWith);

    int colorCodeInt = num.tryParse(colorCode) as int;
    Color selectedColor = Color(colorCodeInt);
    Repository rep= Repository();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add new category'),
        backgroundColor: Colors.deepPurpleAccent,
        /*leading: GestureDetector(
          onTap: () {
         //   Navigator.of(context).pushReplacementNamed('/homePage');
          },
          child: Icon(
            Icons.arrow_back,
          ),
        ),*/
      ),
      body: Column(
          children: [ Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child:  TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Category name'),

                )
              ),

            ],
          ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // primary: pickerColor,
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  padding: const EdgeInsets.only(
                      left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
              onPressed: (() {
                colorPickerDialog();
              }),
              child: const Text('PICK COLOR'),
            ),
          ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          final category = Label();
          category.namec= _categoryController.text;
          category.colorlbl=colorCodeInt as int?;

          var result = await rep.insertData("Labelnotes", category.lblMap());
          Navigator.pop(context, true);

        },
        child: Text("OK"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
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
}