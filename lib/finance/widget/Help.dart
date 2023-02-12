import 'package:flutter/material.dart';
class help extends StatefulWidget {
  const help({Key? key}) : super(key: key);

  @override
  State<help> createState() => _helpState();
}

class _helpState extends State<help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
    title: new Text('Help!'),
    backgroundColor:  Colors.deepPurpleAccent,
    ),

    body: SingleChildScrollView(
   padding: EdgeInsets.all(20),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children:[

    Text("How to use: ", style: TextStyle( fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),),
      Text(" \n\n  First:",  style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),),
   Row(children:[ Container( width: 100, height: 100, decoration: BoxDecoration(image: const DecorationImage(fit: BoxFit.fill, image:const  AssetImage("images/Sans titre(2).png")) ),),
          Text(" \n     Add contact category (Family , work, \n     friends, neigbors, ...etc.)"),]),
          Text(" \n\n  Second:\n",  style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),),
        Row(children:[  Text(" \n  Add organized contact from your  \n  phone contact to the \n  categories you created. "),
          Container( width: 100, height: 100, decoration: BoxDecoration(image:const DecorationImage(fit: BoxFit.fill, image: const AssetImage("images/Sans titre(3).png")) ),),
          ]),
          Text(" \n\n  Third:",  style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),),
          Row(children:[
            Container( width: 100, height: 100, decoration: BoxDecoration(image:const DecorationImage(fit: BoxFit.fill, image: const AssetImage("images/Sans titre(4).png")) ),),
            Container( width:250, child:Text(" \n Once the contact is added to the organized ones, it will be colored with the category color and you can launch a call, launch an eamil or set a reminder to receive a notification reminding you to call or mail the person.  "),)]),
          Text(" \n\n  Forth:",  style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),),
        Row(children:[ Container( width: 100, height: 100, decoration: BoxDecoration(image:const DecorationImage(fit: BoxFit.fill, image:const AssetImage("images/Sans titre(5).png")) ),),
          Text(" \n\n  Add categories for notes and todos\n and label your texts and todo lists \n within them. Then check your progress\n with your todolist"),]),
          Text(" \n\n  Fivth:",  style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),),
        Row(children:[   Text(" \n\n  Set events with colors and check \n  them on calendar daily, monthly,  \n  and yearly. \n\n"),
          Container( width: 100, height: 100, decoration: BoxDecoration(image:const DecorationImage(fit: BoxFit.fill, image:const AssetImage("images/Sans titre(6).png")) ),),
        ]),
          Text(" \n\n  Sixth:",  style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),),
         Row(children:[ Container( width: 100, height: 100, decoration: BoxDecoration(image:DecorationImage(fit: BoxFit.fill, image:AssetImage("images/Sans titre(7).png")) ),),
          Text(" \n\n  Set reminders for events and check\n  them on calendar as well."),]),
          Text(" \n\n  Seventh:",  style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),),
          Row(children:[   Text(" \n\n  Manage your wallet and count your\n savings incomes and outcome, and\n check you financial situation with\n  a daily, weekly, monthly, and yearly\n  chart. \n\n\n"),
            Container( width: 100, height: 100, decoration: BoxDecoration(image:DecorationImage(fit: BoxFit.fill, image:AssetImage("images/Sans titre(8).png")) ),),
          ]),

          Text(
            /*" \n\n  Add contact category( Family , work, friends, neigbors, ...etc. \n\n "
        "Second: Add organized contact from your phone contact to the categories you created. \n\n "
        "Third: Once the contact is added to organized ones it will be colored with the category color and you can launch a call, lanch an eamil or set a reminder to launch them automatically and receive a notification 5 minutes before launching them. \n\n"
        "Forth: Add categories for notes and todos and label your texts and todo lists within them. \n\n"
        "Fivth: Set events with colors and check them on calendar daily, monthly, and yearly. \n\n"
        "Sixth: Set reminders for events and check them on calendar as well. \n\n"
        "Seventh: Manage your wallet and count your savings incomes and outcome, and check you financial situation with a daily, weekly, monthly, and yearly chart. \n\n\n"*/
        "If you still have any ambiguity contact: bechmanel@gmail.com", style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold),), ])))
    ;
  }
}
