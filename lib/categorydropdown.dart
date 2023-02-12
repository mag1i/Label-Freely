import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:labelfreely/Models/Category.dart';
import 'package:labelfreely/phones.dart';
import 'package:labelfreely/database/servicescnt.dart';
import 'drawer.dart';
import 'widgets/Add/Addreminder.dart';
import 'widgets/Edits/EdirCategory.dart';

import 'contactbycategory.dart';
import 'main.dart';
import 'organized.dart';



class cat extends StatefulWidget {
  cat({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<cat> {
  late List<Categor> _userList = <Categor>[];
  final _userService = UserService();

  getAllUserDetails() async {
    var users = await _userService.readAllCategories();
    _userList = <Categor>[];
    users.forEach((user) {
      setState(() {
        var userModel = Categor();
        userModel.idc = user['idlabel'];
        userModel.namec = user['namelabel'];
        userModel.colorlbl = user['colorlabel'];

        _userList.add(userModel);
      });
    });
  }

  @override
  void initState() {
    getAllUserDetails();
    super.initState();
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

 _deleteFormDialog(BuildContext cntxt, ctId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are You Sure to Delete? You will lose all organized contacts in this category',
              style: TextStyle(color: Colors.teal, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.red),
                  onPressed: ()  async{
                    var result=await _userService.deletecat(ctId);
                    if (result != null) {
                      Navigator.pop(context);
                      getAllUserDetails();
                      _showSuccessSnackBar(
                          'Category Deleted Success');
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
              clr=pickerColor.value;

              Navigator.of(context).pop(false);
            },
            child: const Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
  final _categoryController = TextEditingController();
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  UserService categoryOperations = UserService();
  Color pickerColor =  Color(0xff2196f3);
  _addFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (param) {
         /* var color =
          pickerColor.toString().replaceAll(RegExp(r'(?:_|[^\w\s])+'), '');
          var rSpaceColor = color.replaceAll(RegExp(r'(\s)'), '');

          var rcolorText = rSpaceColor.toLowerCase().replaceAll(RegExp(r'color'), '');

          var materialPrimaryvalue = 'materialprimaryvalue'.toLowerCase();
          var replaceWith = '';
          var colorCode = rcolorText.replaceAll(materialPrimaryvalue, replaceWith);

          int colorCodeInt = num.tryParse(colorCode) as int;
          Color selectedColor = Color(colorCodeInt);*/

          return AlertDialog(
          title: const Text(
            'Add contact category',
            style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 20),
          ),
          actions: [ Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
            Row(children: [
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

                final category = Categor();
                category.namec= _categoryController.text;
                category.colorlbl=clr as int?;

                var result = await categoryOperations.SaveCategory(category);
                getAllUserDetails();
                Navigator.pop(context, result);
                _categoryController.text=" ";

              },
              child: const Text('Add'),
            ),])
          ]);});}
  late int clr;
  drawer d = drawer();
  @override
  Widget build(BuildContext context) {
    int _selectedIndex=0;
    return Scaffold(
      drawer: d.drwer(context),

      appBar: AppBar(
        title: const Text("Contact Categories"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
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
              Navigator.push(context,  MaterialPageRoute(builder: (context) => const phones())) .then((data) {
                if (data != null) {
                  getAllUserDetails();
                  _showSuccessSnackBar('Category Added');
                }
              });
              break;
            case 3:
            //  rep.deleteDataById("cont",  _userList.last.id);
              _addFormDialog(context);

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
            label: 'add remind',
            icon: Icon(Icons.add_alert_outlined),

          ),
          BottomNavigationBarItem(
            label: 'Add contact',
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
    /*  GridView.builder(

          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).orientation ==
          Orientation.landscape ? 3: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: (2 / 1),
    ),
          itemCount: _userList.length,
          itemBuilder: (context, index) {*/
    SingleChildScrollView( child: Container(

    width: 500,
    height: 700,

    child:

      GridView.extent(
      childAspectRatio: (4 / 2),
    crossAxisSpacing: 4,
    mainAxisSpacing: 4,
    padding: EdgeInsets.all(5.0),
    maxCrossAxisExtent: 200.0,
    children: List.generate(_userList.length, (index) {
            return Container(
                decoration: BoxDecoration(
                 /* boxShadow: [
                    BoxShadow(
                      //color: Color.fromRGBO(47, 125, 121, 0.3),
                      color: Colors.deepPurple,
                      offset: Offset(0, 6),
                      blurRadius: 12,
                      spreadRadius: 6,
                    ),
                  ],*/
                  // color: Color.fromARGB(255, 47, 125, 121),

                ),
                child: Card(
                  shape: RoundedRectangleBorder( //<-- SEE HERE
                    side: BorderSide(
                      color: Color(_userList[index].colorlbl as int),
                      width: 3,

                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ), 
                  color:  Color(_userList[index].colorlbl as int).withOpacity(0.4),
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute( builder: (context) => contegory(
                              catid: _userList[index].idc as int,
                                  categ: _userList[index].namec as String,
                          )));
                },
                onLongPress: (){
                      _deleteFormDialog(context, _userList[index].idc);
                      getAllUserDetails();

                   },
                //leading: const Icon(Icons.label),
                title: Center( child: Text((_userList[index].namec ?? ''), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey[30]),) ),
                //subtitle:
                trailing: IconButton(
                  onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => EditCategory(
            ct: _userList[index],
            ))).then((data) {
            if (data != null) {
            getAllUserDetails();
            _showSuccessSnackBar(
            'Ctegory Updated');
            }
            });
            ;
            },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.teal,
                )),
              ),
            ));
          })))),

      );
  }}
