

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:labelfreely/percentage.dart';
import 'package:labelfreely/database/servicescnt.dart';
import 'package:url_launcher/url_launcher.dart';

import 'drawer.dart';
import 'widgets/Add/AddLabel.dart';
import 'widgets/Add/AddNotes.dart';
import 'widgets/Add/Addcategpry.dart';
import 'widgets/Add/Addreminder.dart';
import 'finance/widget/Help.dart';
import 'database/repository.dart';
import 'labeldata.dart';
import 'main.dart';
import 'notedetail.dart';
import 'organized.dart';



class catnotes extends StatefulWidget {
  catnotes({Key? key, required this.idnt}) : super(key: key);
int idnt;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<catnotes> {
  Repository rep= new Repository();
  late List<Label> _ctgrList = <Label>[];
  getAllLabelDetails() async {
    var users = await rep.readData("Labelnotes");
    _ctgrList = <Label>[];
    users.forEach((user) {
      setState(() {
        var userModel = Label();
        userModel.idc = user['idlabel'];
        userModel.namec = user['namelabel'];
        userModel.colorlbl = user['colorlabel'];

        _ctgrList.add(userModel);
      });
    });
  }
  late List<Notes> _notesList = <Notes>[];
  getAllNotesDetails(d) async {
    var todos = await rep.readDataBylabel("notes", d);
    _notesList = <Notes>[];
    todos.forEach((user) {
      if (this.mounted) {

        setState(() {
        var userModel = Notes();
        userModel.id = user['id'];
        userModel.content = user['content'];
        userModel.idlbl = user['idlbl'];
        userModel.date = user['date'];
        userModel.title = user['title'];
        userModel.image = user['image'];
        _notesList.add(userModel);
      });}
    });}
  late int fknclr;

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
              fknclr=pickerColor.value;
              clr=pickerColor.value;
              Navigator.of(context).pop(false);
            },
            child: const Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  deleteNotes(BuildContext context, nt) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are You Sure to this note?',
              style: TextStyle(color: Colors.teal, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.red),
                  onPressed: ()  async{

                      var result=await rep.deleteDataById("notes", nt);

                      if (result != null) {
                        Navigator.pop(context, result);
                        getAllNotesDetails(widget.idnt);
                        getAllLabelDetails();
                        _showSuccessSnackBar(
                            'Note Deleted Success');
                      }
                   },
                  child: const Text('Delete')),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.teal),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }
  _deleteFormDialog(BuildContext context, lblid) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are You Sure to Delete? You will lose all the notes in this categoty',
              style: TextStyle(color: Colors.teal, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.red),
                  onPressed: ()  async{
                    if(lblid!=1){
          var result=await rep.deletectgrById("Labelnotes", lblid);
          /*   labelid=1;
                      if (result != null) {*/
          Navigator.pop(context, result);
          getAllLabelDetails();
          _showSuccessSnackBar(
          'Categoty Deleted Success');
          }},
                   // }}else{ _showSuccessSnackBar(                        "You can't delete the main category");}},
                  child: const Text('Delete')),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.teal),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }
  late int idlbl=1;
  late int s;
  @override
  void initState() {
    super.initState();
    clr=0;
   // idlbl =1;
    s=0;

    getAllLabelDetails();
    getAllNotesDetails(widget.idnt);
  }

  final _categoryController = TextEditingController();
  UserService categoryOperations = UserService();

  _addFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (param) {



          return AlertDialog(
              title: const Text(
                'Add category',
                style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 20),
              ),
              actions: [ Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                          border:  OutlineInputBorder(), labelText: 'Category name'),
                    ),
                  ),

                ],
              ),
                Row(  children: <Widget>[
                  const SizedBox(width: 10,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // primary: pickerColor,
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      padding: const EdgeInsets.only(
                          left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
                  onPressed: (() {
                    colorPickerDialog();
                  }),
                  child: const Text('PICK COLOR'),
                ),
                  const SizedBox(width: 60,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // primary: pickerColor,
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      padding: const EdgeInsets.only(     left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
                  onPressed: () async {

                    final lbl = Label();
                    lbl.namec= _categoryController.text;
                    lbl.colorlbl=clr;

                    var result = await rep.insertData("Labelnotes", lbl.lblMap());

                    Navigator.pop(context, result);
                    getAllLabelDetails();

                  },
                  child: const Text('Add'),
                )]),
              ]);});}
  late int clr;
  int _selectedIndex=0;

  @override
  Widget build(BuildContext context) {

    Utility u=  Utility();
    drawer d = drawer();
    return Scaffold(
        drawer:d.drwer(context),
        floatingActionButton: Container(
            decoration: BoxDecoration(
              color:  Colors.white,
              borderRadius: BorderRadius.all( Radius.circular(50.0)),
              border: Border.all(
                color: Colors.white,
                width: 4.0,
              ),
            ),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MyApp()));
              },
              child: Icon(Icons.home),
              backgroundColor: Colors.deepPurpleAccent,
              //  backgroundColor: Color(0xff368983),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    body:


    SingleChildScrollView( child:


      //scrollDirection: Axis.vertical,
     Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      //  mainAxisSize: MainAxisSize.min,
      children: <Widget>[

      Container(

          margin: const EdgeInsets.symmetric(vertical: 20.0),
      height: 60.0,
      child:
      ListView.builder(

      shrinkWrap: true,
      scrollDirection: Axis.horizontal,

      //padding: EdgeInsets.fromLTRB(110, 5, 5, 1),
      //scrollDirection: Axis.v
      itemCount: _ctgrList.length,
      itemBuilder: (context, index) {

      return SingleChildScrollView( child: Container(
      width: 170.0,
      height: 100,
      child: Card(
      shape: RoundedRectangleBorder( //<-- SEE HERE
      side: BorderSide(
      color: Color(_ctgrList[index].colorlbl as int),
      width: 5,

      ),
      borderRadius: BorderRadius.circular(40.0),
      ),

      color: Color(_ctgrList[index].colorlbl as int).withOpacity(0.4),


      child: ListTile(
      trailing: IconButton(
      onPressed: () { _deleteFormDialog(context, _ctgrList[index].idc! );},
      //tooltip: 'Add Item',
      icon: Icon(Icons.highlight_remove_rounded),
      //   color: Colors.red,
      ),
      title:Text(_ctgrList[index].namec as String, style:TextStyle(fontWeight: FontWeight.bold, fontSize: 14), ),
      onTap: () {

        widget.idnt=_ctgrList[index].idc as int;
        idlbl=_ctgrList[index].idc as int;
      setState(() {
    //  labelid=_ctgrList[index].idc as int;
      widget.idnt=_ctgrList[index].idc as int;
      idlbl=_ctgrList[index].idc as int;
      getAllNotesDetails( widget.idnt);
      });

      },))));

      }
      //your widget items here

      )),
      SingleChildScrollView( child: Container(
      width: 500,
      height: 600,
      child:
    GridView.extent(
      childAspectRatio: (3 / 3),
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      padding: EdgeInsets.all(35.0),
      maxCrossAxisExtent: 200.0,
    children:
    List.generate(_notesList.length, (index) {

    var d=_ctgrList.where((m) {
      return m.idc==widget.idnt;
    });
    s=  d.first.colorlbl as int;
   // if(_notesList[index]!.idlbl==labelid){
      //getAllNotesDetails(labelid);
    return
    Column( children: [
 //   SizedBox(height: 25,),

    /*  ListView.builder(

                shrinkWrap: true,
                //  padding: EdgeInsets.fromLTRB(110, 5, 5, 1),
                //scrollDirection: Axis.v
                itemCount: _notesList.length,
                itemBuilder: (context, index) {
                  var ddd=_ctgrList.where((m) {
                    return m.idc==widget.idcat;
                  });
                  s=  ddd.first.colorlbl as int;
                  if(_notesList[index]!.idlbl==widget.idcat){
                    return SingleChildScrollView(
                        child: Container(
                        width: 200,
                        height: 100,*/
    Card(

    shape: RoundedRectangleBorder(

    borderRadius: BorderRadius.circular(15.0)),
    //color: Color(s ),

    child:Container(
    decoration: BoxDecoration(image:DecorationImage(fit: BoxFit.fill, image:AssetImage("images/notect.png")),
    borderRadius: BorderRadius.circular(15),

    color: Color(s).withOpacity(0.4),
    ) ,
    child: ListTile(

    onTap: () {
    Navigator.push(context, MaterialPageRoute(builder:(context)=> notesdetail(nt:_notesList[index] )));
    },

    /*  leading: CircleAvatar(
                            child: Text(_notesList[index].title![0]),
                            backgroundColor:  Colors.deepPurpleAccent,
                          ),*/
    // trailing: IconButton(
    onLongPress:  () {
      deleteNotes(context, _notesList[index].id);
     // deleteNotes(context, _notesList[index].id);
    // rep.deleteDataById("notes", );
      getAllNotesDetails( widget.idnt);
    },
    //tooltip: 'Add Item',

    title:  Text("\n\n" +(_notesList[index].title!.length >8? _notesList[index].title!.substring(0, 7): _notesList[index].title as String ), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),),
    trailing:   (_notesList[index].image!=".") ? CircleAvatar(radius: 30,
    backgroundImage: MemoryImage(u.dataFromBase64String(_notesList[index].image! as String)),
    ): Text(""),
    /*  trailing:   (_notesList[index].image==".") ? CircleAvatar(child: Icon(Icons.note),backgroundColor:  Colors.deepPurpleAccent,):CircleAvatar(
                            backgroundImage: MemoryImage(u.dataFromBase64String(_notesList[index].image! as String)),
                          ),*/
    subtitle: Text("\n\n\n" +(_notesList[index].date as String)+"\n\n ", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),),
    ))),

    ]);
    //subtitle: Text(_userList[index].number ?? ''),

    }
    /*padding: EdgeInsets.symmetric(vertical: 8.0),
        children: _todoList.map((Todo todo) {
          return TodoItem(
            todo: todo,
            onTodoChanged: _handleTodoChange,
          );
        }).toList(),*/
    ),
    ))),

      ])),
      bottomNavigationBar:         BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepPurpleAccent,
        selectedItemColor: Colors.white.withOpacity(.60),
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _selectedIndex,

        onTap: (int index) {
          switch (index) {
            case 4:
              Navigator.push(context, MaterialPageRoute(builder:(context)=> MyApp()));
              // only scroll to top when current index is selected.
              if (_selectedIndex == index) {
                /*_homeController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );*/
              }
              // launch('tel: ${n}');
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder:(context)=> MyApp()));

              break;
            case 1:

              Navigator.push(context, MaterialPageRoute(builder:(context)=> AddNotes(idlbl: widget.idnt)));
              getAllNotesDetails(idlbl);
              break;
            case 3:

              _addFormDialog(context);
              getAllLabelDetails();


              break;
            case 0:
              Navigator.push(context, MaterialPageRoute(builder:(context)=> addreminder()));
              break;

          }


          setState(
                () {
              _selectedIndex = index;
            },
          );
        },

        /*onTap: (int ind) {
          Index 0: launch('tel: ${n}');
          // FlutterContacts.openExternalEdit(widget.contact.id);
         // widget.contact.delete();


        },*/
        items: [
          BottomNavigationBarItem(
            label: 'Add remind',
            icon: Icon(Icons.add_alert_outlined),

          ),
          BottomNavigationBarItem(
            label: 'Add Notes',
            icon: Icon(Icons.add_task_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Add categor',
            icon: Icon(Icons.add_road_sharp),
          ),
          BottomNavigationBarItem(

            label: 'Back',
            icon: Icon(Icons.arrow_back),

          ),

        ],
      ),



      appBar: AppBar(
        title: const Text("Notes"),
        backgroundColor: Colors.deepPurpleAccent,
      ),);}}
class Notes {
  int? id;
  String? content;
  int? idlbl;
  String? date;
  String? title;
  String? image;
  notesMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id ?? null;
    mapping['content'] = content!;
    mapping['idlbl'] = idlbl!;
    mapping['date'] = date!;
    mapping['title'] = title!;
    mapping['image'] = image!;
    return mapping;
  }
}
