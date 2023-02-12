import 'package:flutter/material.dart';
import 'categortnotes.dart';
import 'imageview.dart';
import 'labeldata.dart';
import 'database/repository.dart';

class notesdetail extends StatefulWidget {
  const notesdetail({Key? key, required this.nt}) : super(key: key);
  final Notes nt;

  @override
  State<notesdetail> createState() => _notesState();
}

class _notesState extends State<notesdetail> {
  Repository rep=new Repository();
  var control= TextEditingController();
  var controltitle= TextEditingController();
  late double? h;

  @override
  void initState() {

     control.text=widget.nt.content as String;
     controltitle.text =widget.nt.title as String;
      }
      Utility u = new Utility();
  @override
  Widget build(BuildContext context) {
    (widget.nt.image!=".") ? h=230: h=40;
    return Scaffold(
        appBar: new AppBar(
        title:  TextField(

          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3, color: Colors.deepPurpleAccent)),
               labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black54)),
          keyboardType: TextInputType.multiline,
          /* decoration: InputDecoration(
            hintText: widget.nt.content,

          ),*/

          controller: controltitle,
          onChanged: (value) {
            widget.nt.title = value;
            //  rep.updatNote( widget.nt.id,   widget.nt.content);

          },
          maxLines: 1,
        ),
    backgroundColor:  Colors.deepPurpleAccent,
    ),
      body:  SingleChildScrollView (
          padding: EdgeInsets.fromLTRB(10, 10, 10, 1),

          child: Column(mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max, children :[
            Container(width:200 ,height: h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // primary: pickerColor,
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)),
                    padding: const EdgeInsets.only(
                        left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
              child:  (widget.nt.image!=".") ? Ink.image(image: MemoryImage(u.dataFromBase64String(widget.nt.image! as String)), height:210,
                  width:220, fit: BoxFit.cover): Text("Add image"),
              onPressed: (){ Navigator.push(context, MaterialPageRoute(builder:(context)=> imageview(nt: widget.nt )));},),
              decoration:  (widget.nt.image!=".") ? BoxDecoration(image:DecorationImage(fit: BoxFit.fill, image:MemoryImage(u.dataFromBase64String(widget.nt.image! as String)),) ):BoxDecoration(),),
        //  CircleAvatar(radius: 30,  backgroundImage: MemoryImage(u.dataFromBase64String(_notesList[index].image! as String)),
   // Text(   widget.nt.content as String, style:TextStyle( fontSize: 20),),),
        SizedBox(height: 20 ),
                TextField(

          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
              width: 3, color: Colors.deepPurpleAccent)),
              labelText: widget.nt.title as String, labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black54)),
          keyboardType: TextInputType.multiline,
         /* decoration: InputDecoration(
            hintText: widget.nt.content,

          ),*/

          controller: control,
          onChanged: (value) {
            widget.nt.content = value;
          //  rep.updatNote( widget.nt.id,   widget.nt.content);

          },
          maxLines: 200,
        ),

        ])


      ),
      floatingActionButton:   Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
        /*    boxShadow: [
              BoxShadow(
                //color: Color.fromRGBO(47, 125, 121, 0.3),
                color: Colors.deepPurple,
                offset: Offset(0, 6),
                blurRadius: 12,
                spreadRadius: 6,
              ),
            ],
            // color: Color.fromARGB(255, 47, 125, 121),
            color: Colors.deepPurpleAccent,*/
            borderRadius: BorderRadius.circular(15),
          ),
          child:    ElevatedButton(
              style: ElevatedButton.styleFrom(
                // primary: pickerColor,
                  backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.0)),
                  padding: const EdgeInsets.only(
                      left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
              child: Text("Save"),
              onPressed: () async {
                rep.updatNote(  widget.nt.id,   widget.nt.content);
              rep.updatNotetitle(  widget.nt.id,   widget.nt.title);
              Navigator.push(context, MaterialPageRoute(builder:(context)=> catnotes( idnt: widget.nt.idlbl as int )));}))
    );
  }}
