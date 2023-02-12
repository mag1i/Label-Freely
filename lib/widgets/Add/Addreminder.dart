import 'package:date_time_picker/date_time_picker.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:labelfreely/reminder.dart';

import '../../Alarm.dart';
import '../../database/repository.dart';



class addreminder extends StatefulWidget {
  const addreminder({Key? key}) : super(key: key);

  @override
  State<addreminder> createState() => _addreminderState();
}

class _addreminderState extends State<addreminder> {
  var _EventController = TextEditingController();

  late DateTime stardate;
  late int _HourEnd;
  late int _MinEnd;
  late DateTime endate;
  late int min=0;
  late int hr=0;
  late int fknclr;
  bool _validateevent= false;
  bool _validatehour= false;
  bool _validatemin= false;
  Repository rep = Repository();
  late Color pickerColor= Color(0xff2196f3);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }
  late Color currentColor;
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
      min=_time.minute;
      hr=_time.hour;
    }
  }
  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  @override
  void initState() {
    fknclr=0XFF7E57C2;
    hr=13;
    min=0;
    _HourEnd=hr+1;
    _MinEnd=min;
    stardate=DateTime.now();
    endate=stardate;
    super.initState();
  }
  final NotificationService _notificationService = NotificationService();
  @override
  Widget build(BuildContext context) {

      var color =
      pickerColor.toString().replaceAll(RegExp(r'(?:_|[^\w\s])+'), '');
      var rSpaceColor = color.replaceAll(RegExp(r'(\s)'), '');

      var rcolorText = rSpaceColor.toLowerCase().replaceAll(RegExp(r'color'), '');

      var materialPrimaryvalue = 'materialprimaryvalue'.toLowerCase();
      var replaceWith = '';
      var colorCode = rcolorText.replaceAll(materialPrimaryvalue, replaceWith);

      int colorCodeInt = num.tryParse(colorCode) as int;
      Color selectedColor = Color(colorCodeInt);
      Future colorPickerDialog() {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: pickerColor,

                onColorChanged: changeColor,
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)),
                    padding: const EdgeInsets.only(
                        left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
                onPressed: () {
                  fknclr=pickerColor.value;
                  Navigator.of(context).pop();
                },
                child: const Text('OK', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        );
      }
      return Scaffold(
          appBar: AppBar(  title: const Text("Add Reminder"), backgroundColor: Colors.deepPurpleAccent,),
          body: SingleChildScrollView(
    // padding: const EdgeInsets.all(15),
    child: Container(
              height:780,
              width: 410,

              decoration: BoxDecoration(image:DecorationImage(fit: BoxFit.fill, image:AssetImage("images/remind.png")) ),
            child: Column( children:[
              SizedBox(height: 300,),
               // alignment: Alignment.topCenter,
                 Text(
                  '  Add Reminder. It will be saved in Calendar \n',
                  style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 18, fontWeight: FontWeight.bold),
                ),

                  /* TextButton(
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2005, 1, 1),
                        maxTime: DateTime(2029, 1, 1),
                        theme: DatePickerTheme(
                            headerColor: Colors.grey,
                            backgroundColor: Colors.blueGrey,
                            itemStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                            doneStyle:
                            TextStyle(color: Colors.white, fontSize: 16)),
                        onChanged: (date) {
                          print('change $date in time zone ' +
                              date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          print('confirm $date');
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Text(
                    'Choose date',
                    style: TextStyle(color: Colors.green),
                  )),*/

                  TextField(
                      controller: _EventController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Reminder of?',
                        labelText: '   Reminder',
                        errorText:
                        _validateevent ? 'Reminder title Can\'t Be Empty' : null,
                      )),
                  const SizedBox(
                    height: 20.0,
                  ),
                  DateTimePicker(
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: '     Date',
                    onChanged: (val) => stardate=DateTime.parse(val as String),

                    validator: (val) {
                      print(val);
                      stardate=DateTime.parse(val as String);
                      return null;
                    },
                    //onSaved: (val) => print(val),
                    onSaved: (val) =>   stardate=DateTime.parse(val as String),
                  ),
        SizedBox(height:30),
              Row(children: [
                SizedBox(width: 40,),

              TextButton(
              style: ElevatedButton.styleFrom(
                // primary: pickerColor,
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  padding: const EdgeInsets.only(
                      left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
                    onPressed: (() {
                      _selectTime();
                    }),
                    child: Text(' Pick Time', style: TextStyle(color: Colors.white),),
                  ),
                SizedBox(width: 40,),

                TextButton(
                      style: ElevatedButton.styleFrom(
                        //primary: pickerColor,
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          padding: const EdgeInsets.only(
                              left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
                      onPressed: (() {
                        colorPickerDialog();
                      }),
                      child: const Text('PICK COLOR', style: TextStyle(color: Colors.white),),
                    ),
              ]),
                  const SizedBox(
                    height: 20.0,
                  ),





                  Row( children: <Widget>[

                    SizedBox(width: 40,),
                   TextButton(
                       style: ElevatedButton.styleFrom(
                         //primary: pickerColor,
                           backgroundColor: Colors.deepPurpleAccent,
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(5.0)),
                           padding: const EdgeInsets.only(
                               left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('CANCEL',  style: TextStyle(color: Colors.white),)),
                    SizedBox(width: 50,),
                   TextButton(
                       style: ElevatedButton.styleFrom(
                         //primary: pickerColor,
                           backgroundColor: Colors.deepPurpleAccent,
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(5.0)),
                           padding: const EdgeInsets.only(
                               left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
                        onPressed: ()  {
                          //  setState(() async{
                          _EventController.text.isEmpty
                              ? _validateevent = true
                              : _validateevent = false;


                          Event evnt= Event();
                          if (_validateevent == false &&
                              _validatemin == false ) {
                            evnt.eventName = _EventController.text+" 《¤》";
                            evnt.startdate = stardate.toString();
                            //evnt.starthour=int.parse(_HourController.text);

                            evnt.starthour = hr;
                            // evnt.startmin=int.parse(_MinController.text) ?? 0;
                            evnt.startmin = min ?? 0;
                            evnt.enddate = endate.toString();
                            //_HourEnd==0? evnt.endhour = hr+1: evnt.endhour=_HourEnd;
                            evnt.endhour = hr+1;
                            _MinEnd==0?
                            evnt.endmin = min : evnt.endmin =_MinEnd ;
                            evnt.background = fknclr;
                            var result = rep.insertData("Events", evnt.eventMap());
                            //  eventsDetails();
                            _EventController.text=" ";
                            print(evnt.id.toString());
                            _notificationService.scheduleNotifications(
                                id: 1,
                                title:evnt.eventName,
                                body: "You have " +( evnt.eventName as String)+" now",
                                time: DateTimeField.combine(stardate, _time));
                            print(DateTimeField.combine(stardate, _time));


                            Navigator.push(context, MaterialPageRoute( builder: (context) => reminder()));
                          }
                          // }  });
                          // var result=await _userService.deleteUser(userId);
                          // if (result != null) {

                          _showSuccessSnackBar( 'Event added');

                        },
                        child: const Text('ADD',  style: TextStyle(color: Colors.white),)),


                  ]
                  ),])
    )));

    }
  }

