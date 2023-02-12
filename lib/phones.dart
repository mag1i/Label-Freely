import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'database/servicescnt.dart';
import 'widgets/Add/Add.dart';


class phones extends StatefulWidget {
  const phones({Key? key}) : super(key: key);

  @override
  State<phones> createState() => _phonesState();
}

class _phonesState extends State<phones> {
  List<Contact>? contacts;
  TextEditingController searchController = new TextEditingController();
  List<Contact> contactsFiltered = [];
  late UserService u= new UserService();

  //List <Contact> contacts=[];
  @override
  void initState(){
    super.initState();
    getallcontacts();

  }

  void getallcontacts () async
  {
    if(await FlutterContacts.requestPermission()){
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);}
    setState(() {

    });
  }

  @override

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,

        title: Text("choose a contact to label"),
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

                Navigator.push(context, MaterialPageRoute(builder:(context)=> addcnt(contact: contacts![index])));



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
      //])
    );

  }
}
