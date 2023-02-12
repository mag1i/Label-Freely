import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import 'Models/Category.dart';
import 'Models/Cntct.dart';
import 'database/servicescnt.dart';
import 'organized.dart';
import 'widgets/Edits/Edit.dart';

class ViewUser extends StatefulWidget {
  final Cntct user;

  const ViewUser({Key? key, required this.user}) : super(key: key);

  @override
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  final _userService = UserService();

  late List<Categor> _ctList = <Categor>[];
  getclrDetails() async {
    var useers = await _userService.readAllCategories();

    _ctList = <Categor>[];
    useers.forEach((user) {
      setState(() {
        var userodel = Categor();
        userodel.idc = user['idlabel'];
        userodel.namec = user['namelabel'];
        userodel.colorlbl = user['colorlabel'];

        _ctList.add(userodel);
      });
    });
  }

  @override
  void initState() {

    getclrDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int ss=widget.user.label as int;
    var ddd= _ctList.where((m) {
      return m.idc==ss;
    });
    return Scaffold(
        appBar: AppBar(

          title: Text(widget.user.name!),
          backgroundColor: Color(ddd.first.colorlbl as int),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                "Contact Details",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(ddd.first.colorlbl as int),
                    fontSize: 20),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push( context, MaterialPageRoute( builder: (context) => EditUser( user: widget.user,
                    ))).then((data) {
                      if (data != null) {
                        Navigator.push( context, MaterialPageRoute( builder: (context) => sec(title: "Labeled")));
                               _showSuccessSnackBar( 'User Detail Updated Success');
                      }
                    });
                    ;
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.teal,
                  )),
              const SizedBox(
                height: 20,
              ),
              Row(children:[
                SizedBox(width: 100),
                (widget.user.image==".") ? Container(width: 150, height:150, child: Icon(Icons.person),color: Color(ddd.first.colorlbl as int),):Container(width: 150, height:150,
                  decoration: BoxDecoration(image:DecorationImage(fit: BoxFit.fill, image: MemoryImage(base64Decode(widget.user.image! as String)),
                  ))),]),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(width: 80),
                  const Text('Name',
                      style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(widget.user.name ?? '', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [   SizedBox(width: 80),
                  const Text('Number',
                      style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(widget.user.number ?? '', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [   SizedBox(width: 80),
                  const Text('Email',
                      style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(widget.user.email ?? '', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),


              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [   SizedBox(width: 80),
                  const Text('Note',
                      style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                 // const SizedBox( height: 20, ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child:
                    Text(widget.user.note ?? '', style: const TextStyle(fontSize: 16))),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              Center(child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // primary: pickerColor,
                    backgroundColor: Colors.deepPurpleAccent.withOpacity(1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    padding: const EdgeInsets.only(
                        left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
                onPressed: () {
                  Navigator.push( context, MaterialPageRoute( builder: (context) => EditUser( user: widget.user,
                  ))).then((data) {
                    if (data != null) {
                      Navigator.push( context, MaterialPageRoute( builder: (context) => sec(title: "Labeled")));
                      _showSuccessSnackBar( 'User Detail Updated Success');
                    }
                  });
                  ;
                },
                child: const Text('Edit contact'),
              )),
            ],
          ),
        ));
  }
}