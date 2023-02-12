import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:labelfreely/percentage.dart';
import 'package:labelfreely/phones.dart';
import 'package:labelfreely/database/servicescnt.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Addreminder.dart';
import '../../Models/Category.dart';
import '../../finance/widget/Help.dart';
import '../../categorydropdown.dart';
import '../../main.dart';
import '../../organized.dart';



class AddCategoryPage extends StatefulWidget {
  AddCategoryPage({ Key? key}) : super(key: key);

  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
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
int _selectedIndex=0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new conatct category'),
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


      body:SingleChildScrollView( child: Container(
        width:450,
    height:700,
    decoration: BoxDecoration(image:DecorationImage(fit: BoxFit.fill, image:AssetImage("images/dark4.png")) ),
    child:
    Column(
        children: [

            SizedBox(height: 240),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Category name'),
              ),
            ),


      SizedBox(height: 20,),
      Container(
          //padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            // color: Color.fromARGB(255, 47, 125, 121),
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(15),
          ),child:
          TextButton(
            style: ElevatedButton.styleFrom(
               // primary: pickerColor,
              backgroundColor: Colors.deepPurpleAccent.withOpacity(1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                padding: const EdgeInsets.only(
                    left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
            onPressed: (() {
              colorPickerDialog();
            }),
            child: const Text('PICK COLOR', style: TextStyle(color: Colors.white),),
          ),),
          SizedBox(height: 40,),
      Container(
        //padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(

            // color: Color.fromARGB(255, 47, 125, 121),
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(15),
          ),child:
          TextButton(
            style: ElevatedButton.styleFrom(
              // primary: pickerColor,
                backgroundColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                padding: const EdgeInsets.only(     left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
              onPressed: () async {

                final category = Categor();
                category.namec= _categoryController.text.trim();
                category.colorlbl=colorCodeInt as int?;

                var result = await categoryOperations.SaveCategory(category);
                Navigator.push(context, MaterialPageRoute(builder:(context)=> cat()));

              },
            child: const Text('Add' ,style: TextStyle(color: Colors.white),),
          ),)
        ]
      ),

    )));
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