import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labelfreely/database/servicescnt.dart';

import '../../categortnotes.dart';
import '../../database/repository.dart';


class AddNotes extends StatefulWidget {
  AddNotes({ Key? key, required this.idlbl}) : super(key: key);
  final int idlbl;
  @override
  _AddNotesPageState createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<AddNotes> {
  final _titleController = TextEditingController();
  final _NoteController = TextEditingController();
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Repository rep= Repository();
  late List<Notes> _notesList = <Notes>[];
  getAllNotesDetails() async {
    var todos = await rep.readData("notes");
    _notesList = <Notes>[];
    todos.forEach((user) {
      setState(() {
        var userModel = Notes();
        userModel.id = user['id'];
        userModel.content = user['content'];
        userModel.idlbl = user['idlbl'];
        userModel.date = user['date'];
        userModel.title = user['title'];
        userModel.image = user['image'];

        _notesList.add(userModel);
      });
    });}
  UserService categoryOperations = UserService();
  Color pickerColor = const Color(0xff2196f3);
  //Color currentColor = const Color(0xff443a49);
  late String df;
final ImagePicker imgpicker = ImagePicker();
String imagepath = "";
  late Uint8List f;

  openImage() async {
    try {
      var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
      //you can use ImageCourse.camera for Camera capture
      if(pickedFile != null){
        imagepath = pickedFile.path;
        print(imagepath);
        //output /data/user/0/com.example.testapp/cache/image_picker7973898508152261600.jpg

        File imagefile = File(imagepath); //convert Path to File
        Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
        String base64string = base64.encode(imagebytes);
        df=base64.encode(imagebytes);
        df=base64string;

        //convert bytes to base64 string
        //   print(base64string+"nnnnnnnnnnnnnnnnnnnnnnnnnn");
        /* Output:
              /9j/4Q0nRXhpZgAATU0AKgAAAAgAFAIgAAQAAAABAAAAAAEAAAQAAAABAAAJ3
              wIhAAQAAAABAAAAAAEBAAQAAAABAAAJ5gIiAAQAAAABAAAAAAIjAAQAAAABAAA
              AAAIkAAQAAAABAAAAAAIlAAIAAAAgAAAA/gEoAA ... long string output
              */

        Uint8List decodedbytes = base64.decode(base64string);
        f=decodedbytes;
       // widget.contact.photo=decodedbytes;
        //decode base64 stirng to bytes
        return base64string;
        setState(() {

        });
      }else{
        print("No image is selected.");
      }
    }catch (e) {
      print("error while picking file.");
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    df=" ";
    super.initState();
  }
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
        title: Text('Add new note'),
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
      body:  Container(
   // decoration: BoxDecoration(image:DecorationImage(fit: BoxFit.fill, image:AssetImage("images/nt.png"))),

    width: 500,
    height: 800,
    child:    SingleChildScrollView( child: Column(

          children: [
           SizedBox(height: 20,),
           // SizedBox(height: 100,),
            Padding(
                padding: const EdgeInsets.fromLTRB(15,15, 20, 10),
                child:  TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(   borderSide: BorderSide(
                          width: 3, color: Colors.deepPurpleAccent)), labelText: 'Note Title'),
                )
            ),

            SingleChildScrollView(
               // scrollDirection: Axis.vertical,
                child: Container (

                width: 400,
                height: 400,
padding: EdgeInsets.fromLTRB(10, 5, 10, 1),
                child:Center(child:
              //SizedBox(height: 100,),
              TextField(
                controller: _NoteController,

                    decoration: InputDecoration(labelText: ' Note',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3, color: Colors.deepPurpleAccent)),),

                        keyboardType: TextInputType.multiline,
                        //     minLines: 1,//Normal textInputField will be displayed
                        maxLines: 200

              )),


          )),
            SizedBox(height: 30,),
       ElevatedButton(
              style: ElevatedButton.styleFrom(
                // primary: pickerColor,
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  padding: const EdgeInsets.only(
                      left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
              child:const Text('Add picture'),
              onPressed: (() {
                openImage();
              }),
          ),
          ]
    ))) ,
      floatingActionButton: FloatingActionButton(
        onPressed: ()  async {


          final note = Notes();
          _titleController.text.isEmpty?
          note.title= " " :   note.title=_titleController.text;
          note.content=_NoteController.text;
          note.idlbl= widget.idlbl;
          setState(() {


       //   (df==null) ? BoxDecoration(image:DecorationImage(fit: BoxFit.fill, image:AssetImage("images/1.jpg")),):BoxDecoration(image:DecorationImage(fit: BoxFit.fill, image:MemoryImage(f)));
          (df==" ") ?  note.image="." :  note.image=df;
          String d= DateTime.now().day.toString()+"/" + DateTime.now().month.toString()+ "/"+ DateTime.now().year.toString();
          note.date= d;});

          var result= await rep.insertData("notes", note.notesMap());
          _NoteController.text=" ";

          Navigator.push(context, MaterialPageRoute(builder:(context)=> catnotes(idnt: widget.idlbl, )));
getAllNotesDetails();
       },
        child: Text("Ok"),
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