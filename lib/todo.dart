import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:labelfreely/percentage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'drawer.dart';
import 'widgets/Add/AddLabel.dart';
import 'widgets/Add/Addcategpry.dart';
import 'widgets/Add/Addreminder.dart';
import 'finance/widget/Help.dart';
import 'database/repository.dart';
import 'main.dart';
import 'organized.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoState();
}


class _TodoState extends State<TodoList> {
  Repository rep= Repository();
  late List<Todo> _todoList = <Todo>[];
  getAlltodoDetails() async {
    var todos = await rep.readData("Todos");
    _todoList = <Todo>[];
    todos.forEach((user) {
      setState(() {
        var userModel = Todo();
        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.idlbl = user['idlbl'];
        userModel.checked = user['checked'];
        userModel.date = user['date'];
       _todoList.add(userModel);
      });
    });}
  late int fknclr;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }
  late int clr;
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
  } late List<Label> _ctgrList = <Label>[];
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
   late int labelid;
  late int s;
  @override
  void initState() {
    super.initState();
    s=0;
    labelid=1;

      getAllLabelDetails();
      getAlltodoDetails();


  }

  @override
  Widget build(BuildContext context) {
    _addFormDialog(BuildContext context) {
      return showDialog(
          context: context,
          builder: (param) {
            var color =
            pickerColor.toString().replaceAll(RegExp(r'(?:_|[^\w\s])+'), '');
            var rSpaceColor = color.replaceAll(RegExp(r'(\s)'), '');

            var rcolorText = rSpaceColor.toLowerCase().replaceAll(RegExp(r'color'), '');

            var materialPrimaryvalue = 'materialprimaryvalue'.toLowerCase();
            var replaceWith = '';
            var colorCode = rcolorText.replaceAll(materialPrimaryvalue, replaceWith);

            int colorCodeInt = num.tryParse(colorCode) as int;
            Color selectedColor = Color(colorCodeInt);
            final _categoryController = TextEditingController();
            return AlertDialog(
                title: const Text(
                  'Add category',
                  style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 20),
                ),
                actions: [ Column(
                 // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: _categoryController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Category name'),
                      ),
                    ),

                  ],
                ),
                  Row( children:[
                    SizedBox(width: 10,),
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
                  SizedBox(width: 60,),
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
                      lbl.colorlbl=clr as int?;

                      var result = await rep.insertData("Labelnotes", lbl.lblMap());
                      _categoryController.text=" ";

                      Navigator.pop(context, result);
                      getAllLabelDetails();

                    },
                    child: const Text('Add'),
                  )]),
                ]);});}
      Future<void> _displayDialog() async {
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

        return showDialog<void>(
          context: context,
         // barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            var g=pickerColor;
            return SingleChildScrollView( child: AlertDialog(
              title: const Text('Add a new todo item'),
              content: TextField(
                controller: _textFieldController,
                decoration: const InputDecoration(hintText: 'Type your new todo'),
              ),
              actions: <Widget>[
                TextButton(

                  child: const Text('Cancel' ),
                  onPressed: () {
                    clr=pickerColor.value;
                    Navigator.of(context).pop();
                  }
                ),
           /*     ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:  Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0)),
                      padding: const EdgeInsets.only(
                          left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
                  onPressed: (() {
                     colorPickerDialog();
                  }),
                  child: const Text('PICK COLOR'),
                ),*/
                TextButton(
                  child: const Text('Add'),

                  onPressed: () {
                    Navigator.of(context).pop();
                    Todo td =Todo();
                 //   setState(() async {
                      td.name=_textFieldController.text;
                      td.checked=0;
                      String d= DateTime.now().day.toString()+"/" + DateTime.now().month.toString()+ "/"+ DateTime.now().year.toString();
                      td.date= d;
                      td.idlbl=labelid;
                    //  td.colr=fknclr;

                       rep.insertData("Todos", td.todoMap());
                       getAlltodoDetails();
                    _textFieldController.text=" ";
                   // });


                    //_addTodoItem(_textFieldController.text);

                  },
                ),
              ],
            ));
          },
        );
      }

    _showSuccessSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
    _deleteFormDialog(BuildContext context, lblid) {
      return showDialog(
          context: context,
          builder: (param) {
            return AlertDialog(
              title: const Text(
                'Are You Sure to Delete? You will lose all the todos in this categoty',
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
                      labelid=1;
                      if (result != null) {
                        Navigator.pop(context);
                        getAllLabelDetails();
                        _showSuccessSnackBar(
                            'Todo list caategoty Deleted Success');
                      }
                    }else{ _showSuccessSnackBar(
                      "You can't delete the main category");}},
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
    drawer d= drawer();
int _selectedIndex=0;
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Todo list'),
          backgroundColor:  Colors.deepPurpleAccent,
        ),
        drawer: d.drwer(context),

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
                Navigator.pop(context);
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

                _displayDialog();
                break;
              case 3:

                _addFormDialog(context);
                getAllLabelDetails();


                break;
              case 0:
                Navigator.push(context, MaterialPageRoute(builder:(context)=> percentage()));
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
              label: 'Progress',
              icon: Icon(Icons.percent_outlined),

            ),
            BottomNavigationBarItem(
              label: 'Add Todo',
              icon: Icon(Icons.add_task_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.menu),
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
        body:

    SingleChildScrollView(
        //scrollDirection: Axis.vertical,
        child:Column(

            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
        //  mainAxisSize: MainAxisSize.min,
          children: <Widget>[
        //    SizedBox(height: 150,),
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

                    color: Color(_ctgrList[index].colorlbl as int).withOpacity(0.6),


                    child: ListTile(
                      trailing: IconButton(
                        onPressed: () { _deleteFormDialog(context, _ctgrList[index].idc! );},
                        //tooltip: 'Add Item',
                        icon: Icon(Icons.highlight_remove_rounded),
                     //   color: Colors.red,
                      ),
                      title:Text(_ctgrList[index].namec as String, style:TextStyle(fontWeight: FontWeight.bold, fontSize: 14), ),
                      onTap: () {
                        setState(() {
                          labelid=_ctgrList[index].idc as int;


                        });
                      },))));}
                //your widget items here

              )),
        SingleChildScrollView( child: Container(

            width: 500,
            height: 600,
            child:
              ListView.builder(
                  scrollDirection: Axis.vertical,
                shrinkWrap: true,
              //  padding: EdgeInsets.fromLTRB(110, 5, 5, 1),
                //scrollDirection: Axis.v
            itemCount: _todoList.length,
            itemBuilder: (context, index) {
              var ddd=_ctgrList.where((m) {
                return m.idc==labelid;
              });
               s=  ddd.first.colorlbl as int;
              if(_todoList[index].idlbl==labelid){
              return  Card(
                  shape:  RoundedRectangleBorder( //<-- SEE HERE
              side: BorderSide(
              color: Color(s),
              width: 3,

              ),
              borderRadius: BorderRadius.circular(20.0),
              ),

              color: Color(s ).withOpacity(0.4),
                  child: ListTile(
                    onTap: () {
                    setState(() {
                       if(_todoList[index].checked==0){_todoList[index].checked=1;
                       rep.updatetodo( _todoList[index].id, 1);}
                       else{_todoList[index].checked=0;
                       rep.updatetodo( _todoList[index].id, 0);}
                     });
                    },

                   /* leading: CircleAvatar(
                      child:  Container(
              // width: 100.0,
              // height: 100.0,
              decoration: BoxDecoration(
              color:  Color(s),
              borderRadius: BorderRadius.all( Radius.circular(50.0)),
              border: Border.all(
              color: Color(s),
              width: 2.0,
              ),
              ), child:Text(_todoList[index].name![0].toUpperCase())),
                      backgroundColor:  Colors.deepPurpleAccent,
                    ),*/
                    trailing: IconButton(
                        onPressed: () { rep.deleteDataById("Todos", _todoList[index].id);
                            getAlltodoDetails();},
                        //tooltip: 'Add Item',
                        icon: Icon(Icons.delete),
                      color: Colors.red,
                    ),
                    title:  Text(_todoList[index].name ?? '', style: getteststyle(_todoList[index].checked),),
                    subtitle: Text(_todoList[index].date as String),
                  ));}else{
                return Container( );
              }
              //subtitle: Text(_userList[index].number ?? ''),

            }
          /*padding: EdgeInsets.symmetric(vertical: 8.0),
        children: _todoList.map((Todo todo) {
          return TodoItem(
            todo: todo,
            onTodoChanged: _handleTodoChange,
          );
        }).toList(),*/
              ))),
])),

      );
    }

  var _textFieldController = TextEditingController();
getteststyle(check){
  if (check==1){return TextStyle(
    color: Colors.black54,
    decoration: TextDecoration.lineThrough,
  );} else {return TextStyle(fontWeight: FontWeight.bold);}
}



}
class Todo {
  int? id;
  String? name;
  int? idlbl;
  int? checked;
  String? date;
  todoMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id ?? null;
    mapping['name'] = name!;
    mapping['idlbl'] = idlbl!;
    mapping['checked'] = checked!;
    mapping['date'] = date!;



    return mapping;
  }
}
