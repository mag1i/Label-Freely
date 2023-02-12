import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labelfreely/Models/Cntct.dart';
import 'package:labelfreely/labeldata.dart';
import 'package:labelfreely/database/servicescnt.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../Models/Category.dart';
class EditUser extends StatefulWidget {
  final Cntct user;
  const EditUser({Key? key,required this.user}) : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  List<Contact>? cnt;


  var _userNameController = TextEditingController();
  var _userNoteController = TextEditingController();
  var _userEmailController = TextEditingController();
  var _userNumberController = TextEditingController();
  var _userlblController;
  bool _validateName = false;
  bool _validateNote = false;
  bool _validateNumber = false;
  bool _validateEmail = false;
  var _userService=UserService();
  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";
  Utility u=Utility();
  String im="";
  var cn;


  void getallcontacts () async
  {
    if(await FlutterContacts.requestPermission()){
      cnt = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);}
    setState(() {

    });
  }

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
        print(base64string+"nnnnnnnnnnnnnnnnnnnnnnnnnn");
        im=base64string;
        /* Output:
              /9j/4Q0nRXhpZgAATU0AKgAAAAgAFAIgAAQAAAABAAAAAAEAAAQAAAABAAAJ3
              wIhAAQAAAABAAAAAAEBAAQAAAABAAAJ5gIiAAQAAAABAAAAAAIjAAQAAAABAAA
              AAAIkAAQAAAABAAAAAAIlAAIAAAAgAAAA/gEoAA ... long string output
              */

        Uint8List? decodedbytes = base64.decode(base64string);
        var cnn= cnt?.where((m) {
          return m.id.toString()==widget.user.id;

        });
        cnn!.first.photo=decodedbytes;
        print(cnn.first.displayName);



        widget.user.image=base64string;

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

  late List<Categor> _ctgrList = <Categor>[];
  getAllcCategDetails() async {
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

  @override
  void initState() {
    setState(() {
      getallcontacts();
       cn= cnt?.where((m) {
        return m.id.toString()==widget.user.id;
      });


      getAllcCategDetails();
      _userNameController.text=widget.user.name??'';
      _userNoteController.text=widget.user.note??'';
      _userEmailController.text=widget.user.email??'';
      _userNumberController.text=widget.user.number??'';
      _userlblController=widget.user.label?? 1;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

   // fknclr=ddd.first.colorlbl as int;
    var ctgryModel = Categor();


    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit "),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Contact',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Name',
                    labelText: 'Name',
                    errorText:
                    _validateName ? 'Name Value Can\'t Be Empty' : null,
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
                    errorText: _validateNote
                        ? 'Contact Value Can\'t Be Empty'
                        : null,
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
                        ? 'Description Value Can\'t Be Empty'
                        : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),

              TextField(
                  controller: _userNumberController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Number',
                    labelText: 'Number',
                    errorText: _validateNumber
                        ? 'Description Value Can\'t Be Empty'
                        : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              DropdownButton<Categor>(
                  hint: Text('Select category'),
                  onChanged: (Categor? value){
                    setState(() {
                      ctgryModel = value!;
                      print(ctgryModel.namec);
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
                  }).toList()),
              const SizedBox(
                height: 20.0,
              ),
              Row(children:[
                SizedBox(width: 150),
              (widget.user.image==".") ? CircleAvatar(child: Icon(Icons.person),backgroundColor: Colors.deepPurpleAccent,):CircleAvatar(
                backgroundImage: MemoryImage(u.dataFromBase64String(widget.user.image! as String)),
              ),]),
        Row(children:[
              SizedBox(width: 110),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // primary: pickerColor,
                    backgroundColor: Colors.deepPurpleAccent.withOpacity(1),),
                onPressed: (() async {
                  openImage();
               //   cn.first.photo!=base64Decode(im);

                }),
                child: const Text('Change image'),

              )]),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 60.0,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () {
                        _userNameController.text = '';
                        _userNoteController.text = '';
                        _userEmailController.text = '';
                        _userNumberController.text = '';

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

                          _userNameController.text.isEmpty
                              ? _validateName = true
                              : _validateName = false;
                          _userNoteController.text.isEmpty
                              ? _validateNote = true
                              : _validateNote = false;
                          _userEmailController.text.isEmpty
                              ? _validateEmail = true
                              : _validateEmail = false;
                          _userNumberController.text.isEmpty
                              ? _validateNumber = true
                              : _validateNumber = false;


                        });
                        if (_validateName == false &&
                            _validateNote == false &&
                            _validateEmail == false && _validateNumber == false) {
                          // print("Good Data Can Save");
                          var _user = Cntct();
                          _user.id=widget.user.id;
                          _user.name = _userNameController.text;
                          _user.note = _userNoteController.text;
                          _user.email = _userEmailController.text;
                          _user.number = _userNumberController.text;
                          _user.label = _userlblController;
                          _user.image=widget.user.image;



                          var result=await _userService.UpdateUser(_user);
                          Navigator.pop(context,result);
                        }
                      },
                      child: const Text('Update Details')),




                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}