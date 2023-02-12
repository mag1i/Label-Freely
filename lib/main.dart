import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:labelfreely/percentage.dart';
import 'package:labelfreely/reminder.dart';
import 'package:labelfreely/todo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'database/servicescnt.dart';
import 'drawer.dart';
import 'finance/data/model/add_date.dart';
import 'widgets/Add/Addcategpry.dart';
import 'Alarm.dart';
import 'finance/widget/Help.dart';
import 'categortnotes.dart';
import 'categorydropdown.dart';
import 'finance/Screens/home.dart';
import 'organized.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AdddataAdapter());
  await Hive.openBox<Add_data>('data');
  var initializationSettingsAndroid = AndroidInitializationSettings('codex_logo');


  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); //
  await NotificationService().requestIOSPermissions();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static late ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context, ) {

    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
    return MaterialApp(
      debugShowCheckedModeBanner : false,
      title: 'Free Label',
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData.dark(),
      themeMode: currentMode,
     // theme: ThemeData.light(),
     // darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'Home'),
    );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact>? contacts;
  TextEditingController searchController = new TextEditingController();
  List<Contact> contactsFiltered = [];
  late UserService u= new UserService();
  late int islight=10;
  //List <Contact> contacts=[];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState(){
    super.initState();

        _prefs.then((SharedPreferences prefs) {
          islight = prefs.getInt('counter') ?? 0;
      return prefs.getInt('counter') ?? 0;

    });
    getmode();


   // getallcontacts();

  }


  void getallcontacts () async
  {
    if(await FlutterContacts.requestPermission()){
    contacts = await FlutterContacts.getContacts(
        withProperties: true, withPhoto: true);}
    setState(() {

    });
  }
rr() async {

  final SharedPreferences prefs = await _prefs;
  setState(() {
    prefs.getInt('counter')==1?
    prefs.setInt('counter', 0):  prefs.setInt('counter', 1);
    islight= prefs.getInt('counter')!;
    print(islight.toString());
  });
}
 getmode() async {
   final SharedPreferences prefs = await _prefs;
   islight= prefs.getInt('counter')!;
   MyApp.themeNotifier.value =
   //  MyApp.themeNotifier.value == ThemeMode.light
   islight==0
       ? ThemeMode.light
       : ThemeMode.dark;
  }
drawer d= drawer();
  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,

        title: Text(widget.title),  ),
        drawer: d.drwer(context),
      body:Container(
         decoration:   BoxDecoration(image:DecorationImage(fit: BoxFit.fill, image:AssetImage("images/zz.png")) ),
          child:
    GridView.extent(

    childAspectRatio: (4 / 3),
    crossAxisSpacing: 4,
    mainAxisSpacing: 4,
    //padding: EdgeInsets.all(20.0),
    maxCrossAxisExtent: 200.0,
        padding: EdgeInsets.fromLTRB(1, 80, 20, 20),

    children:[
   SizedBox(height: 20),SizedBox(height: 20),


      Column(
          children:[
            Container(
                width: 120,
                height: 120,
                child:
ElevatedButton(
  style: ElevatedButton.styleFrom(
    // primary: pickerColor,
      backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)),
      padding: const EdgeInsets.all(10)
  ),
  onPressed:(){  Navigator.push(context, MaterialPageRoute(builder:(context)=> sec(title: '',)));}
    , child: Column(children:[
  Text("\n ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 3)),

  Icon(Icons.contacts_outlined, size: 45,),
      Text(" Organized \n  Contacts", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
     ])
//Ink.image(image: AssetImage("images/b.png"), height:100,  width:100, fit: BoxFit.cover),
)),
     /* InkWell(

        splashColor: Colors.deepPurpleAccent,
      onTap:(){  Navigator.push(context, MaterialPageRoute(builder:(context)=> sec(title: '',)));},
        child: Ink.image(image: AssetImage("images/b.png"), height:100,
            width:100, fit: BoxFit.cover),

      ),*/
     //   Text("Organized Contacts")

    ]),

      Column( children:[
        Container(
            width: 120,
            height: 120,
            child:
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              // primary: pickerColor,
                backgroundColor:  Colors.deepPurpleAccent.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                padding: const EdgeInsets.all(10)),
            onPressed:(){  Navigator.push(context, MaterialPageRoute(builder:(context)=> cat()));}
            , child:  Column(children:[
          Text("\n ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 2)),

          Icon(Icons.category, size: 45,),
        Text("   Contact \n  Categories", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
      ])

        )),
       // Text("Contact categories")

      ]),
     // SizedBox(height: 0.2),
     //SizedBox(height: 0.2),
      Column( children:[
        Container(
            width: 120,
            height: 120,
            child:
        ElevatedButton(
          
            style: 
            ElevatedButton.styleFrom(
              // primary: pickerColor,
                backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                padding: const EdgeInsets.all(10)),
            onPressed:(){  Navigator.push(context, MaterialPageRoute(builder:(context)=> TodoList()));}
            , child: Column(children:[
          Text("\n ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 2)),

          Icon(Icons.checklist_outlined, size: 45, ),
          Text(" Todo \n  List", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
        ])

        )),
       // Text("Todo")

      ]),

      Column( children:[
        Container(
            width: 120,
        height: 120,
        child:
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              // primary: pickerColor,
                backgroundColor:  Colors.deepPurpleAccent.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                padding: const EdgeInsets.all(10)),
            onPressed:(){  Navigator.push(context, MaterialPageRoute(builder:(context)=> catnotes(idnt: 1,)));}
            , child:   Column(children:[
            Text("\n ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 5)),
        Icon(Icons.note_sharp, size: 45,),
        Text(" Notes ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
      ])

        )),
       // Text("Notes")

      ]),
      Column( children:[
        Container(
            width: 120,
            height: 120,
            child:
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              // primary: pickerColor,
                backgroundColor:  Colors.deepPurpleAccent.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                padding: const EdgeInsets.only(
                    left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
            onPressed:(){ Navigator.push(context, MaterialPageRoute(builder:(context)=> Home()));}
            , child:   Column(children:[
          Text("\n ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 6)),

          Icon(Icons.account_balance_wallet, size: 45,),
          Text(" Manage \n Wallet  ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
        ])

        )),
       // Text("Wallet")

      ]),

      Column( children:[
        Container(
            width: 120,
            height: 120,
            child:
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              // primary: pickerColor,
                backgroundColor:  Colors.deepPurpleAccent.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                padding: const EdgeInsets.only(
                    left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
            onPressed:(){ Navigator.push(context, MaterialPageRoute(builder:(context)=> reminder()));}
            , child:  Column(children:[
          Text("\n ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 6)),

          Icon(Icons.calendar_month, size: 45,),
          Text("Manage \n Events ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
        ])

        )),
       // Text("Events and Appointments")

      ]),
    ]))
      /*
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
         Navigator.push(context, MaterialPageRoute(builder:(context)=> Bottom()));


        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
        ],
      ),

      body: (contacts==null) ? Center(

       child: CircularProgressIndicator() ):
        //  Column(  children: <Widget>[


       ListView.builder(


        itemCount: contacts!.length,
        itemBuilder: (BuildContext context, int index){
          Uint8List? image= contacts![index].photo;
          String num=(contacts![index].phones.isNotEmpty)? contacts![index].phones.first.number.toString():"---";
          return ListTile(

            leading: (image==null) ? CircleAvatar(child: Icon(Icons.person),backgroundColor:  Colors.deepPurpleAccent,):CircleAvatar(
              backgroundImage: MemoryImage(image),


            ),
            title: Text(contacts![index].name.first),
            subtitle: Text(num),

            onTap: (){

              if (contacts![index].phones.isNotEmpty) {

                  Navigator.push(context, MaterialPageRoute(builder:(context)=> details(contact: contacts![index])));



             // launch('tel: ${num}');
              }
            },

          );


        },


      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,

        onPressed: () {

          FlutterContacts.openExternalInsert();
        },
        child: const Icon(Icons.add),
      ),





         // mainAxisAlignment: MainAxisAlignment.center,
       /*   children: <Widget>[
            ListView.builder(
            //    itemCount: contacts.length,
                itemBuilder: (context, index){
                //  Contact cnt= contacts[index];
                  return ListTile(
                   // title: Text(cnt.displayName.toString()),
                    title: Text("ghghf"),
                  //  subtitle: Text(cnt.phones.elementAt(0).value.toString():cnt.phones.elementAt(0).value!=null)?,
                  );},)
          ],*/


     /* floatingActionButton: FloatingActionButton(
       // onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    //])*/
      );
  }
}
