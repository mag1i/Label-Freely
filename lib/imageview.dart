import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'categortnotes.dart';
import 'database/repository.dart';
import 'labeldata.dart';
import 'notedetail.dart';



class imageview extends StatefulWidget {
  const imageview({Key? key, required this.nt}) : super(key: key);
final Notes nt;
  @override
  State<imageview> createState() => _imageviewState();
}

class _imageviewState extends State<imageview> {
  Utility u= new Utility();
  Repository rep= new Repository();
  String imagepath = "";
  late String df;
  final ImagePicker imgpicker = ImagePicker();

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
  editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (param) {
      return AlertDialog(
          title: const Text(
            'Save image?',
            style: TextStyle(color: Colors.teal, fontSize: 20),
          ),
          actions: [
      TextButton(
      style: TextButton.styleFrom(
      primary: Colors.white, // foreground
          backgroundColor: Colors.deepPurpleAccent),
    onPressed: ()  async{
      setState(() {

        (df==" ") ?  widget.nt.image="." :  widget.nt.image=df;
        rep.updateData("notes", widget.nt.notesMap());
       // Navigator.of(context).pop(false);
        Navigator.push(context, MaterialPageRoute(builder:(context)=> notesdetail( nt: widget.nt )));
      });
    },
    child: Text("Save"),)

    ]);});}
    @override
  void initState() {
    // TODO: implement initState
    df=" ";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,

        title: Text("View Image"),
    ),
        body: Container(
      decoration:  (widget.nt.image!=".") ? BoxDecoration(image:DecorationImage(fit: BoxFit.fill, image:MemoryImage(u.dataFromBase64String(widget.nt.image! as String)),) ):BoxDecoration(),),

        floatingActionButton:  Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [FloatingActionButton(
          // FlatButton(
        child:  widget.nt.image!="." ?  Icon(Icons.edit):Icon(Icons.add) ,
          backgroundColor: Colors.teal,
          onPressed: () async {
            openImage();
            Timer(Duration(seconds: 3), () {
              editFormDialog(context);
            });

          },
        ),
          const SizedBox(
            width: 190.0,
          ),
          FloatingActionButton(
            backgroundColor: Colors.redAccent,
            onPressed: () {
              setState(() {

                widget.nt.image=".";
                rep.updateData("notes", widget.nt.notesMap());
                Navigator.push(context, MaterialPageRoute(builder:(context)=> notesdetail( nt: widget.nt )));
              });

            },
            child: const Icon(Icons.delete),) ,

])

    //),

    );
  }
}
