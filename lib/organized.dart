
import 'package:flutter/material.dart';
import 'package:labelfreely/percentage.dart';
import 'package:labelfreely/phones.dart';
import 'package:labelfreely/remind.dart';
import 'package:labelfreely/widgets/Add/Addreminder.dart';

import 'package:url_launcher/url_launcher.dart';

import 'Models/Category.dart';
import 'Models/Cntct.dart';
import 'database/servicescnt.dart';

import 'drawer.dart';
import 'labeldata.dart';
import 'main.dart';
import 'widgets/Add/Addcategpry.dart';

import 'finance/widget/Help.dart';
import 'database/repository.dart';
import 'orgdetails.dart';




class sec extends StatefulWidget {
  sec({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _secState createState() => _secState();
}
class _secState extends State<sec> {
  late List<Cntct> _userList = <Cntct>[];
  late List<Categor> _ctList = <Categor>[];

  final _userService = UserService();
  final rep = Repository();
  late Categor ct= Categor();
  late int ss=0;
  late Utility u= Utility();

  getAllUserDetails() async {
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
  ff(int y){
    rep.readclrById(y).then((data){
      if (mounted){
        setState (() =>fknclr =  data);}
        //fknclr =  data;
    });}

  late int fknclr=0;




  @override
  void initState() {
    getAllUserDetails();
    getclrDetails();




    super.initState();
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _deleteFormDialog( cntxt, userId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are You Sure to Delete',
              style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.red),
                  onPressed: ()  async{
          setState(() {

          var result= _userService.deleteUser(userId);
                    if (result != null) {
                      getAllUserDetails();
                      Navigator.pop(context);
                    //  Navigator.push(context,  MaterialPageRoute(builder: (context) => sec(title: '',)));

                      _showSuccessSnackBar(
                          'Organized Contact Deleted Success');
                    }});
                  },
                  child: const Text('Delete')),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.teal),
                  onPressed: ()  {
     //     SchedulerBinding.instance.addPostFrameCallback((_) {  Navigator.pop(context);});
        //  Navigator.push(context,MaterialPageRoute(builder: (context) => sec(title: '',)));
                  //  Navigator.of(context).pop();
                  //  Navigator.of(context,rootNavigator: true).pop();
                   // didChangeDependencies();

                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }

drawer d =drawer();
  @override
  Widget build( context) {
    int _selectedIndex = 0;
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
              Navigator.push(context, MaterialPageRoute(builder:(context)=> MyApp()));

              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder:(context)=> MyApp()));

              break;
            case 1:
              Navigator.push(context,  MaterialPageRoute(builder: (context) => const phones())) .then((data) {
                if (data != null) {
                  getAllUserDetails();
                  _showSuccessSnackBar('User Detail Added Success');
                }
              });
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
      body:
         ListView.builder(
          itemCount: _userList.length,
          itemBuilder: (context, index)    {
            ss=_userList[index].label as int;
           // ff(_userList[index].label as int);
            var ddd= _ctList.where((m) {
              return m.idc==ss;
            });

    if (ddd.isNotEmpty) {
            if(_userList[index].label==1){fknclr=0xFFFFFFFF;}else{
              fknclr=ddd.first.colorlbl as int ;
            }}else{print("lk");}
               return Card(
              shape: RoundedRectangleBorder( //<-- SEE HERE
                side: BorderSide(
                  color: Color(fknclr),
                  width: 3,

                ),
                borderRadius: BorderRadius.circular(20.0),
              ),            //  color:  Color(fknclr),
              child: ListTile(
                onTap: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewUser(
                            user: _userList[index]
                          )));
                },
                onLongPress: (){
                  setState(() {
                    _deleteFormDialog(context, _userList[index].id);
                    //getAllUserDetails();

                  });

                   },
                leading:       Container(
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
                ),),
                title: Text(_userList[index].name ?? ''),
                subtitle: Text(_userList[index].number ?? ''),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                  /*  IconButton(
                        onPressed: () {
                           Navigator.push( context, MaterialPageRoute( builder: (context) => EditUser( user: _userList[index],
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
          }),
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
    );
  }
}