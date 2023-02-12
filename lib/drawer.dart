import 'package:flutter/material.dart';
import 'package:labelfreely/percentage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'widgets/Add/Addcategpry.dart';
import 'finance/widget/Help.dart';
import 'package:shared_preferences/shared_preferences.dart';


class drawer {

  late int islight=10;
  //List <Contact> contacts=[];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();



  drwer(context){
    return Drawer(
      width:300,
      child: ListView(children: [DrawerHeader(
          decoration: BoxDecoration(image:DecorationImage(fit: BoxFit.fill, image:AssetImage("images/kh.png")) ),
          child: Column(
            children: [
              Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.white,  border: Border.all(
                    color: Colors.cyanAccent,
                    width: 3,
                  ),),
                  child:Center(child:  Text(" Label \n  Free", style: TextStyle(color: Colors.deepPurpleAccent),))
              ),
              // Text("LabelFree", style: TextStyle(color:Colors.purple, fontSize: 26),)
            ],
          )),
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
          Navigator.push(context, MaterialPageRoute(builder:(context)=> AddCategoryPage()));
        },leading: Icon(Icons.category),title: Text("Add contact category", style: TextStyle(fontSize: 20),),),

        ListTile(onTap: (){ Navigator.push(context, MaterialPageRoute(builder:(context)=> percentage()));
        },leading: Icon(Icons.percent),title: Text("Progress", style: TextStyle(fontSize: 20),),),
        // SwitchListTile(value: 0,onChanged: ,),
        ListTile(leading:   IconButton(
            icon: Icon(MyApp.themeNotifier.value == ThemeMode.light
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: () async {

              MyApp.themeNotifier.value =
              //  MyApp.themeNotifier.value == ThemeMode.light
              MyApp.themeNotifier.value==ThemeMode.light
                  ? ThemeMode.dark : ThemeMode.light;
              final SharedPreferences prefs = await _prefs;

              prefs.getInt('counter')==1?
              prefs.setInt('counter', 0):  prefs.setInt('counter', 1);
            }),title:MyApp.themeNotifier.value == ThemeMode.light
            ?  Text("Dark Mode", style: TextStyle(fontSize: 20),): Text("Light Mode", style: TextStyle(fontSize: 20),),),


        //  SwitchListTile(value:  theme.setLightMode(),,onChanged: (bool value) {  themeChange.darkTheme = value;} ,),
        Divider(color:Colors.deepPurpleAccent),
        ListTile(onTap: (){ Navigator.push(context, MaterialPageRoute(builder:(context)=> help()));
        },leading: Icon(Icons.help),title: Text("Help", style: TextStyle(fontSize: 20),),),
      ],),);
  }


  }

