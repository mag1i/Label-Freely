import 'dart:async';
import 'dart:math';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/Add/Addreminder.dart';
import 'Alarm.dart';
import 'Models/Cntct.dart';
import 'database/repository.dart';

class Reminder {
  int? id;

  remindMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id ?? null;




    return mapping;
  }
}
class MyNoteScreen extends StatefulWidget {

  const MyNoteScreen({Key? key, required this.cnt}) : super(key: key);
  final Cntct cnt;
  @override
  _MyNoteScreenState createState() => _MyNoteScreenState();
}

class _MyNoteScreenState extends State<MyNoteScreen> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(  title: const Text("Reminder"), backgroundColor: Colors.deepPurpleAccent,),
      body: SingleChildScrollView(
       // padding: const EdgeInsets.all(15),
        child: Container( height:780,
            width: 415,

          decoration: BoxDecoration(image:DecorationImage(fit: BoxFit.fill, image:AssetImage("images/c.png")) ),
          child:

          Column(
          children: [
            SizedBox(height: 350,),
            Row(
              children:  [
                SizedBox(width: 5,),
                Expanded(

                    child: NoteThumbnail(

                        id: 1,
                        color: Color(0xFFFF9C99),
                        title: "Call "+ (widget.cnt.name as String),
                       // content: "You'll have to call "+(widget.cnt.name as String)+ " in 5 minutes \n It will automatically prepare the call for you",
                      content: "You need to call "  +(widget.cnt.name as String),
                        c: widget.cnt,)),
                SizedBox(
                  width: 5,
                ),
                Expanded(

                    child: NoteThumbnail(
                        id: 2,
                        color: Color(0xFF6fefb0),
                        title: "Mail "+ (widget.cnt.name as String),
                      //  content: "You'll have to send email to "+(widget.cnt.name as String)+ " in 5 minutes \n It will automatically prepare the email for you",
                        content: "Send an email to "  +(widget.cnt.name as String),
                    c: widget.cnt,)),
              ],
            ),

          SizedBox(height: 60,),
            Container(
                padding: const EdgeInsets.all(15),

                child:    ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // primary: pickerColor,
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: const EdgeInsets.only(
                            left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
                    child: Text("Add another reminder"),
                    onPressed: () async { Navigator.push(context, MaterialPageRoute(builder:(context)=> addreminder()));}))

          ],
        ),
      ) ),
    );
  }
}

class NoteThumbnail extends StatefulWidget {
  final int id;
  final Color color;
  final String title;
  final String content;
  final Cntct c;

  const NoteThumbnail(
      {Key? key,
        required this.id,
        required this.color,
        required this.title,
        required this.content,
      required this.c})
      : super(key: key);

  @override
  _NoteThumbnailState createState() => _NoteThumbnailState();
}

class _NoteThumbnailState extends State<NoteThumbnail> {
  late DateTime dt;
  DateTime selectedDate = DateTime.now();
  DateTime fullDate = DateTime.now();
call() async {
  if(widget.id==1){
  launch('tel: ${ widget.c.number}');
}
  else{
    String em=  widget.c.email as String;
   // String email = Uri.encodeComponent("bechmanel@gmail.com");
    String subject = Uri.encodeComponent(" ");
    String body = Uri.encodeComponent(" ");
   // print(subject); //output: Hello%20Flutter
    Uri mail = Uri.parse("mailto:$em?subject=$subject&body=$body");
    if (await launchUrl(mail)) {
  //email app opened
  }else{
  //email app is not opened
  }

  }
}
  Future<DateTime> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: selectedDate,
        lastDate: DateTime(2100));
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
      );
      if (time != null) {
        setState(() {
          fullDate = DateTimeField.combine(date, time);
        });
        //TODO
        //schedule a notification
      }
      print(DateTimeField.combine(date, time).toString());
      dt= DateTimeField.combine(date, time);
      _reminformDialog(context);

      return DateTimeField.combine(date, time);
    } else {
      dt=selectedDate;
      _reminformDialog(context);
   //   print(fullDate.toString());
      return selectedDate;
    }
  }

  final NotificationService _notificationService = NotificationService();
  _reminformDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (param) {
      return AlertDialog(
          title: const Text(
            "Save Reminder to remember who you need to call or mail",
            style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 20),
          ),
          actions: [
          ElevatedButton(
            child: Text("Save"),
          style: ElevatedButton.styleFrom(
          // primary: pickerColor,
          backgroundColor: Colors.cyanAccent.withOpacity(0.5),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45.0)),
          padding: const EdgeInsets.only(
          left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),

          onPressed: ()  async {
            _notificationService.scheduleNotifications(
                id:1,
                title: widget.title,
                //body: "You will have to call "+(widget.c.name as String)+" in 5 minutes \n It will automatically prepare the call for you",
                body: widget.content,
                time:dt,
            i:  widget.c.number);

               Timer(dt.add(Duration(minutes: 5)).difference(DateTime.now()), call);
              // Evaluate all the tasks which you want to perform in  terminated state.
              // write the code to be run in background BackgroundFetch.finish(taskId);


          //  new Timer.periodic(new Duration(seconds: 1), _decrementCounter);
            Navigator.pop(context);

          })
      ]);});}
  @override
  Widget build(BuildContext context) {

    Repository rep = new Repository();

    return
    Container(
      height: 230,
      width: 80,
      decoration: BoxDecoration(

        // color: Color.fromARGB(255, 47, 125, 121),
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white70),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(widget.content+ " ,launch 5 mins after the notification time you set", style: TextStyle(color: Colors.white),),
          const SizedBox(
            height: 20,
          ),
         /* Text(fullDate.toString()),
          const SizedBox(
            height: 15,
          ),*/
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                // primary: pickerColor,
                  backgroundColor: Colors.cyanAccent.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.0)),
                  padding: const EdgeInsets.only(
                      left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),

              onPressed: ()  {
                _selectDate(context);

              /*  Reminder rmnd= new Reminder();

              rep.insertData("Reminders", rmnd.remindMap());
                late List<Reminder> _remindList = <Reminder>[];
                var rm = await rep.reasreminder();
    _remindList = <Reminder>[];
    rm.forEach((user)  {
    setState(()  {
    var userModel = Reminder();
    userModel.id = user['id'];

    _remindList.add(userModel);    });
    });
    print("cccccccccccccccccccccccccccccccc");
    print(_remindList.last.id.toString());*/


                print(dt.toString());
                print(dt.toString());
                //await _notificationService.zonedScheduleNotification( 30, " l", DateTime.now().add(const Duration(minutes: 1)),  "hj");
                print(DateTime.now().add(const Duration(minutes: 2)));
                Timer? timer;
               // timer = Timer.periodic(DateTime.now().add(const Duration(minutes: 2)), (Timer t) => f());

              },
              child: const Text("Add reminder")),

        ],
      ),


    );
  }
}