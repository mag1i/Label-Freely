/*import 'package:flutter/material.dart';
import 'package:labelfree/finance/Screens/add.dart';
import 'package:labelfree/finance/Screens/home.dart';
import 'package:labelfree/finance/Screens/statistics.dart';
import 'package:labelfree/main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../categnotes.dart';
import '../../categortnotes.dart';
import '../../categorydropdown.dart';
import '../../organized.dart';
import '../../reminder.dart';
import '../../todo.dart';

class Bottom extends StatefulWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int index_color = 0;
  List Screen = [  Home(), Statistics(),];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:       Drawer(
      width:350,
      child: ListView(children: [DrawerHeader(
          decoration: BoxDecoration(image:DecorationImage(fit: BoxFit.fill, image:AssetImage("images/1.jpg")) ),
          child: Column(
            children: [
              Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.white,  border: Border.all(
                    width: 2,
                  ),),
                  child:Center(child:  Text("Label \n Free"))
              ),
              // Text("LabelFree", style: TextStyle(color:Colors.purple, fontSize: 26),)
            ],
          )),
        ListTile(onTap: (){
          Navigator.push(context, MaterialPageRoute(builder:(context)=> sec(title: '',)));
        }, leading: Icon(Icons.checklist_outlined),title: Text("Organized contact", style: TextStyle(fontSize: 20),),),
        ListTile(onTap: () async {
          String email = Uri.encodeComponent("bechmanel@gmail.com");
          String subject = Uri.encodeComponent("LabelFree Feedback or suggestion ");
          String body = Uri.encodeComponent(" ");
          print(subject); //output: Hello%20Flutter
          Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
          if (await launchUrl(mail)) {
            //email app opened
          }else{
            //email app is not opened
          }
        },
          leading: Icon(Icons.add_task_sharp),title: Text("Feedback or suggestions", style: TextStyle(fontSize: 20),),),
        ListTile(onTap: (){
          Navigator.push(context, MaterialPageRoute(builder:(context)=> cat()));
        },leading: Icon(Icons.category),title: Text("Categories", style: TextStyle(fontSize: 20),),),
        ListTile(onTap: (){ Navigator.push(context, MaterialPageRoute(builder:(context)=> reminder()));
        },leading: Icon(Icons.event),title: Text("My events", style: TextStyle(fontSize: 20),),),
        // SwitchListTile(value: 0,onChanged: ,),
        Divider(color:Colors.purple),
        ListTile(onTap: (){ Navigator.push(context, MaterialPageRoute(builder:(context)=> TodoList()));
        },leading: Icon(Icons.checklist),title: Text("My Todo List", style: TextStyle(fontSize: 20),),),
        ListTile(onTap: (){ Navigator.push(context, MaterialPageRoute(builder:(context)=> catnotes(idnt: 1)));
        },leading: Icon(Icons.note),title: Text("Notes", style: TextStyle(fontSize: 20),),),
        ListTile(onTap: (){ Navigator.push(context, MaterialPageRoute(builder:(context)=> Bottom()));
        },leading: Icon(Icons.account_balance_wallet),title: Text("Finance", style: TextStyle(fontSize: 20),),),],),),
      body: Screen[index_color],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Add_Screen()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurpleAccent,
      //  backgroundColor: Color(0xff368983),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            /*  GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: 30,
                  color: index_color == 0 ? Colors.deepPurpleAccent : Colors.grey,
                ),
              ),*/
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 0;
                  });
                },
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 30,
                  color: index_color == 0 ? Colors.deepPurpleAccent : Colors.grey,
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 1;
                  });
                },
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 30,
                  color: index_color == 1 ? Colors.deepPurpleAccent : Colors.grey,
                ),
              ),


             /* GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 3;
                  });
                },
                child: Icon(
                  Icons.person_outlined,
                  size: 30,
                  color: index_color == 3 ? Colors.deepPurpleAccent : Colors.grey,
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}

 */