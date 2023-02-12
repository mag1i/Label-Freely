import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';

import 'package:flutter_contacts/contact.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labelfreely/database/servicescnt.dart';

import '../../Models/Category.dart';
import '../../Models/Cntct.dart';
import '../../labeldata.dart';
import '../../organized.dart';

class addcnt extends StatefulWidget {
  const addcnt({ required this.contact});
  final Contact contact;


  @override
  State<addcnt> createState() => _addcntState();
}

class _addcntState extends State<addcnt> {
  Cntct c=Cntct();
  var _userNoteController = TextEditingController();
  var _userEmailController = TextEditingController();
  var _userLabelController = TextEditingController();
  var _userLabelColorController = TextEditingController();
  var _userlblController = 1;

  bool _validateNote= false;
  bool _validateEmail = false;
  bool _validateLabel = false;
  bool _validateLabelcolor = false;
  var _userService=UserService();
  Color pickerColor = const Color(0xff2196f3);
  Color currentColor = const Color(0xff443a49);
  late List<Categor> _ctgrList = <Categor>[];
  late List<Cntct> _userList = <Cntct>[];
  getAllUserDetails() async {
    var users = await _userService.readAllCategories();
    _ctgrList = <Categor>[];
    users.forEach((user) {
      setState(() {
        var userModel = Categor();
        userModel.idc = user['idlabel'];
        userModel.namec = user['namelabel'];
        userModel.colorlbl = user['colorlabel'];

        _ctgrList.add(userModel);
      });
    });
  }
  getAllDetails() async {
    var users = await _userService.readAllUsers();
    _userList = <Cntct>[];
    users.forEach((user) {
      setState(() {
        var userModel = Cntct();
        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.note = user['note'];
        userModel.number = user['number'];
        userModel.image = user['image'];
        userModel.email = user['email'];
        userModel.label = user['idlbl'];
        _userList.add(userModel);
      });
    });

  }
  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";

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
        //convert bytes to base64 string
     //   print(base64string+"nnnnnnnnnnnnnnnnnnnnnnnnnn");
        /* Output:
              /9j/4Q0nRXhpZgAATU0AKgAAAAgAFAIgAAQAAAABAAAAAAEAAAQAAAABAAAJ3
              wIhAAQAAAABAAAAAAEBAAQAAAABAAAJ5gIiAAQAAAABAAAAAAIjAAQAAAABAAA
              AAAIkAAQAAAABAAAAAAIlAAIAAAAgAAAA/gEoAA ... long string output
              */

        Uint8List decodedbytes = base64.decode(base64string);
        widget.contact.photo=decodedbytes;
        //decode base64 stirng to bytes

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
    getAllUserDetails();
    getAllDetails();
     _userlblController = 1;
    super.initState();
  }


  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }
/*
  pickImageFromGallery() {

    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString = Utility.base64String(imgFile!.readAsBytesSync());});
  }
*/

  @override
  Widget build(BuildContext context) {

    String nane = widget.contact.displayName;

    var ctgryModel = Categor();
    Utility u= new Utility();

    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.deepPurpleAccent ,
        title: const Text("Add to organized"),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(image:DecorationImage(fit: BoxFit.fill, image:AssetImage("images/dark5.png")) ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 240,),
              Text(
                '     Add ' + nane + ' to organized contact',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20,),
              Center(child: (widget.contact.photo==null) ? CircleAvatar(child: Icon(Icons.person),backgroundColor: Colors.deepPurpleAccent,):CircleAvatar(
                backgroundImage: MemoryImage(widget.contact.photo!),
              )),
        Center(child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            // primary: pickerColor,
              backgroundColor: Colors.deepPurpleAccent.withOpacity(1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              padding: const EdgeInsets.only(
                  left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
                onPressed: (() async {
                  openImage();

                }),
                child: const Text('Add image'),
              )),

              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _userNoteController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Note',
                    labelText: 'Note',
                    errorText:
                    _validateNote ? 'Name Value Can\'t Be Empty' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _userEmailController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Email',
                    labelText: 'Email',
                    errorText: _validateEmail
                        ? 'Contact Value Can\'t Be Empty'
                        : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),

      Container(
        width: 400,
          child:
              DropdownButton<Categor>(
                  hint: Text('                         Select category'),
                  onChanged: (Categor? value){
                    setState(() {
                      ctgryModel = value!;
                     // print(ctgryModel.namec);
                      _userlblController=ctgryModel.idc!;

                      //  widget.callback(value);
                    });
                  //  hint:ctgryModel.namec;
                  },
                  items:_ctgrList.map((category) {
                    return    DropdownMenuItem(
                      value: category,
                      child: Text(category.namec.toString()),
                        );
                  }).toList())),
              const SizedBox(
                height: 20.0,
              ),

              Row(
                children: [
                  SizedBox(
                    width: 80.0,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () {
                        _userNoteController.text = '';
                        _userEmailController.text = '';
                        _userLabelController.text = '';
                        _userLabelColorController.text = '';
                      },
                      child: const Text('Clear Details')),
                  const SizedBox(
                    width: 20.0,
                  ),

                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.teal,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () async {
                        setState(() {
                          _userNoteController.text.isEmpty
                            // ? _validateNote = true
                             ? _userNoteController.text=" "
                              : _validateNote = false;
                          _userEmailController.text.isEmpty
                              //? _validateEmail = true
                              ? _userEmailController.text=" "
                              : _validateEmail = false;
                          _userlblController.isNaN? _userlblController=1: _validateLabel=false;


                        });
                        getAllDetails();
                        var ddd= _userList.where((m) {
                          return m.id==widget.contact.id;
                        });


                        var f = Cntct();

                        var product = _userList.firstWhere((product) => product.id == widget.contact.id, orElse: () => f);

                      //  if(_userList.contains(ddd)){
                        if (product != f ||  _userList.contains(ddd)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Contact already exists in organized"),
                            ),
                          );

                        }
                        else  if (product == f && _userList.contains(ddd)==false) {

                          if (_validateNote == false &&
                            _validateEmail == false
                        ) {

                          // print("Good Data Can Save");
                        var _user = Cntct();
                          Utility u= Utility();
                          _user.id = widget.contact.id.toString();
                          _user.name = widget.contact.displayName;
                          _user.number =
                              widget.contact.phones.first.number.toString();
                          widget.contact.photo== null? _user.image= ".":
                          _user.image = u.base64String(widget.contact.photo!);
                          _user.note = _userNoteController.text;
                          if(widget.contact.emails.isNotEmpty){
                          _user.email =widget.contact.emails.first.address as String;}
                          else{ _user.email= _userEmailController.text;}
                          _user.label=_userlblController;

                          var result = await _userService.SaveUser(_user);


                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>  sec(title: "Organized contacts")));
                        }}
                      },
                      child: const Text('Save Details')),


                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}
 /* final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
      final database = openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), 'doggie_database.db'),
        onCreate: (db, version) {
          // Run the CREATE TABLE statement on the database.
          return db.execute(
            'CREATE TABLE cnt(id INTEGER PRIMARY KEY, name TEXT, number TEXT, image IMAGE note TEXT, email TEXT, label TEXT, labelcolor TEXT)',
          );
        },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1,
      );
    }

    return Form(
        key: _formKey,
        child: Column(
        children: <Widget>[
        // Add TextFormFields and ElevatedButton here.
        ],
    ));
  }
}
*/