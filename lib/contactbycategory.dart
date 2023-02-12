import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:labelfreely/Models/Category.dart';
import 'package:labelfreely/Models/Cntct.dart';
import 'package:labelfreely/percentage.dart';
import 'package:labelfreely/phones.dart';
import 'package:labelfreely/remind.dart';
import 'package:labelfreely/database/servicescnt.dart';
import 'package:url_launcher/url_launcher.dart';

import 'drawer.dart';
import 'widgets/Add/Addcategpry.dart';
import 'widgets/Add/Addreminder.dart';
import 'widgets/Edits/Edit.dart';
import 'finance/widget/Help.dart';
import 'database/repository.dart';
import 'labeldata.dart';
import 'main.dart';
import 'organized.dart';
import 'orgdetails.dart';




class contegory extends StatefulWidget {
  contegory({Key? key, required this.catid, required this.categ}) : super(key: key);
  final String categ;

  final int catid;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<contegory> {
  late List<Cntct> _userList = <Cntct>[];
  late List<Categor> _ctList = <Categor>[];

  final _userService = UserService();
  final rep = Repository();
  late Categor ct= Categor();
  late int ss=0;

  getAllUserDetails() async {
    var users = await rep.readDataByCategory("cont", widget.catid);
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
  /*
  ff(int y){
    rep.readclrById(y).then((data){
      if (mounted){
        setState (() =>fknclr =  data);}
      //fknclr =  data;
    });}*/

  late int fknclr=0;




  @override
  void initState() {
    getAllUserDetails();
    getclrDetails();

    super.initState();
  }
  late Utility u= Utility();

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _deleteFormDialog( cntxt, userId) {
    return showDialog(
        context: cntxt,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are You Sure to Delete',
              style: TextStyle(color: Colors.teal, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.red),
                  onPressed: ()  async{
                    await _userService.deleteUser(userId);

                      getAllUserDetails();
                      Navigator.pop(cntxt, false);
                      _showSuccessSnackBar(
                          'User Detail Deleted Success');

                  },
                  child: const Text('Delete')),
              TextButton(
                  style: TextButton.styleFrom(
                  //    primary: Colors.white, // foreground
                      backgroundColor: Colors.teal),
                  onPressed: () {
                    Navigator.pop(cntxt);
                  },
                  child: const Text('Close', style: TextStyle(color: Colors.white),))
            ],
          );
        });
  }

drawer d = drawer();

  @override
  Widget build(BuildContext context) {

    int _selectedIndex=0;

    return Scaffold(
      drawer: d.drwer(context),

      appBar: AppBar(
        title: const Text("Labeled"),
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
            _showSuccessSnackBar('User Detail Added Success');}});
              break;
            case 3:
            //  rep.deleteDataById("cont",  _userList.last.id);
              Navigator.push(context,  MaterialPageRoute(builder: (context) =>  AddCategoryPage())) ;

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

      body:   SingleChildScrollView( child: Container(

      width: 500,
      height: 600,
      child:
      ListView.builder(
          itemCount: _userList.length,
          itemBuilder: (context, index)    {
            ss=_userList[index].label as int;
            // ff(_userList[index].label as int);
            var ddd= _ctList.where((m) {
              return m.idc==ss;
            });
    if (ddd.isNotEmpty) {
            //ddd.first.colorlbl!= null? fknclr=ddd.first.colorlbl as int: fknclr=0;
            if(_userList[index].label==1){fknclr=0;}else{
              fknclr=ddd.first.colorlbl as int;
            }}else{print("no");}

            return Card(
              shape: RoundedRectangleBorder( //<-- SEE HERE
                side: BorderSide(
                  color: Color(fknclr),
                  width: 3,

                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              // color:  Color(fknclr),
              child: ListTile(
                onTap: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewUser(
                              user: _userList[index]
                          )));
                },
                onLongPress: (){ setState(() {
                  _deleteFormDialog(context, _userList[index].id);
                  getAllUserDetails();
                });

                  },
                leading:     Container(
            // width: 100.0,
            // height: 100.0,
            decoration: BoxDecoration(
            color:  Color(fknclr),
            borderRadius: BorderRadius.all( Radius.circular(50.0)),
            border: Border.all(
            color: Color(fknclr),
            width: 4.0,
            ),
            ), child: (_userList[index].image==".") ? CircleAvatar(child: Icon(Icons.person),backgroundColor:  Colors.deepPurpleAccent,):CircleAvatar(
                  backgroundImage: MemoryImage(u.dataFromBase64String(_userList[index].image! as String)),
                )),

                title: Text(_userList[index].name ?? ''),
                subtitle: Text(_userList[index].number ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                  /*  IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditUser(
                                    user: _userList[index],
                                  ))).then((data) {
                            if (data != null) {
                              getAllUserDetails();
                              _showSuccessSnackBar(
                                  'User Detail Updated Success');
                            }
                          });
                          ;
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.teal,
                        )),*/




                    IconButton(
                        onPressed: () {
                          launch('tel: ${ _userList[index].number}');
                        },
                        icon: const Icon(
                          Icons.call,
                          color: Colors.deepPurpleAccent,
                        )),
                    IconButton(
                        onPressed: () async {
                          String em=  _userList[index].email as String;
                          String email = Uri.encodeComponent("bechmanel@gmail.com");
                          String subject = Uri.encodeComponent(" ");
                          String body = Uri.encodeComponent(" ");
                          print(subject); //output: Hello%20Flutter
                          Uri mail = Uri.parse("mailto:$em?subject=$subject&body=$body");
                          if (await launchUrl(mail)) {
                            //email app opened
                          }else{
                            //email app is not opened
                          }
                        },
                        icon: const Icon(
                          Icons.email,
                          color: Colors.deepPurpleAccent,
                        )),
                    IconButton(
                        onPressed: () async {
                          Navigator.push( context, MaterialPageRoute( builder: (context) => MyNoteScreen( cnt: _userList[index])));
                        },
                        icon: const Icon(
                          Icons.alarm_add,
                          color: Colors.deepPurpleAccent,
                        )),
                    /* FutureBuilder(
                      future: rep.getColor(_userList[index].label),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print('error');
                        //var data = snapshot.data!['lk'].toString() as int;
                        int data = int.parse(snapshot.data!.toString());
                        return Card(
                            child: ListTile(
                            title: Text("ffs"),
                        subtitle: Text('${data}G'),
                        ),);
                      },
                    ),*/

                  ],
                ),
              ),
            );
          }))),
     /* floatingActionButton: FloatingActionButton(
        onPressed: () {
          //  rep.deleteDataById("cont",  _userList.last.id);
          Navigator.push(context,  MaterialPageRoute(builder: (context) => const phones())) .then((data) {
            if (data != null) {
              getAllUserDetails();
              _showSuccessSnackBar('User Detail Added Success');
            }
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.8),

      ),*/
      /* floatingActionButton: FloatingActionButton(
        onPressed: () {



         Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddUser()))
              .then((data) {
            if (data != null) {
              getAllUserDetails();
              _showSuccessSnackBar('User Detail Added Success');
            }
          });
        },
        child: const Icon(Icons.add),
      ),*/
    );
  }
}