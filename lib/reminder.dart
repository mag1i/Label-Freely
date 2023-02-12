
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'widgets/Add/Addreminder.dart';
import 'database/repository.dart';
class reminder extends StatefulWidget {
  const reminder({Key? key}) : super(key: key);

  @override
  State<reminder> createState() => _reminderState();
}
class Event {
  int? id;
  String? eventName;
  String? startdate;
  int? starthour;
  int? startmin;
  String? enddate;
  int? endhour;
  int? endmin;
  int? background;
  eventMap() {
    var mapping = Map<String, dynamic>();
    mapping['idevent'] = id ?? null;
    mapping['nameevent'] = eventName!;
    mapping['startdate'] = startdate !;
    mapping['starthour'] = starthour!;
    mapping['startmin'] = startmin!;
    mapping['enddate'] = enddate ?? startdate;
    mapping['endhour'] = endhour!;
    mapping['endtmin'] = endmin!;
    mapping['colorevent'] = background!;

    return mapping;
  }

}
class _reminderState extends State<reminder> {
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

  late List<Event> _evntList = <Event>[];

  eventsDetails() async {
    var events =  await rep.readData("Events");

    _evntList = <Event>[];
    events.forEach((user) {
      setState(() {
        var userodel = Event();
        userodel.id = user['idevent'];
        userodel.eventName = user['nameevent'];
        userodel.startdate = user['startdate'];
        userodel.starthour = user['starthour'];
        userodel.startmin = user['startmin'];
        userodel.enddate = user['enddate'];
        userodel.endhour = user['endhour'];
        userodel.endmin = user['endtmin'];
        userodel.background = user['colorevent'];

        _evntList.add(userodel);
      });
    });
  }
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
  void _selectendTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
      _MinEnd=_time.minute;
      _HourEnd=_time.hour;
    }
  }
  var _selectedAppointment;
  @override
  void initState() {
    eventsDetails();
    fknclr=0XFF7E57C2;
    hr=13;
    min=0;
    _HourEnd=0;
    _MinEnd=0;
    _selectedAppointment = null;
    stardate=DateTime.now();
    endate=stardate;
    super.initState();
  }
  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
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
            child: const Text('OK', style: TextStyle(color: Colors.deepPurpleAccent)),
          ),
        ],
      ),
    );
  }
  _AddFormDialog(BuildContext context) {
    var color =
    pickerColor.toString().replaceAll(RegExp(r'(?:_|[^\w\s])+'), '');
    var rSpaceColor = color.replaceAll(RegExp(r'(\s)'), '');

    var rcolorText = rSpaceColor.toLowerCase().replaceAll(RegExp(r'color'), '');

    var materialPrimaryvalue = 'materialprimaryvalue'.toLowerCase();
    var replaceWith = '';
    var colorCode = rcolorText.replaceAll(materialPrimaryvalue, replaceWith);

    int colorCodeInt = num.tryParse(colorCode) as int;
    Color selectedColor = Color(colorCodeInt);
    return  showDialog(

        context: context,
        builder: (param) {
          return SingleChildScrollView( child: AlertDialog(
            alignment: Alignment.topCenter,
            title: const Text(
              'Add event or appointment',
              style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 20),
            ),
            actions: [
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
                    hintText: 'Enter event name',
                    labelText: 'Event',
                    errorText:
                    _validateevent ? 'Event Can\'t Be Empty' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
                    DateTimePicker(
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Start Date',
                      onChanged: (val) => stardate=DateTime.parse(val as String),

                      validator: (val) {
                        print(val);
                        stardate=DateTime.parse(val as String);
                        return null;
                      },
                      //onSaved: (val) => print(val),
                      onSaved: (val) =>   stardate=DateTime.parse(val as String),
                    ),
              ElevatedButton(
                onPressed: (() {
                  _selectTime();
                }),
                child: Text('Start Time'),
              ),
              const SizedBox(
                height: 20.0,
              ),


              DateTimePicker(
                initialValue: '',
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                cursorColor: Colors.deepPurpleAccent,
                dateLabelText: 'End Date',
                onChanged: (val) =>endate=DateTime.parse(val as String),
                validator: (val) {
                  print(val);
                  endate=DateTime.parse(val as String);
                  return null;
                },
                //onSaved: (val) => print(val),
                onSaved: (val) =>   stardate=DateTime.parse(val as String),
              ),
              ElevatedButton(

                onPressed: (() {
                  _selectendTime();
                }),


                child: Text('End TIME'),
              ),


          Row( children: <Widget>[


          ElevatedButton(
          style: ElevatedButton.styleFrom(
          //primary: pickerColor,
          backgroundColor: Colors.deepPurpleAccent,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0)),
          padding: const EdgeInsets.only(
          left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
          onPressed: (() {
          colorPickerDialog();
          }),
          child: const Text('PICK COLOR'),
          ),
            TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.white, // foreground
                    backgroundColor: Colors.teal),
                onPressed: ()  {
                  //  setState(() async{
                  _EventController.text.isEmpty
                      ? _validateevent = true
                      : _validateevent = false;


                  Event evnt= Event();
                  if (_validateevent == false &&
                      _validatemin == false ) {
                    evnt.eventName = _EventController.text;
                    evnt.startdate = stardate.toString();


                    evnt.starthour = hr;

                    evnt.startmin = min ?? 0;
                    evnt.enddate = endate.toString();
                    _HourEnd==0?
                    evnt.endhour = hr+1: evnt.endhour=_HourEnd;
                    _MinEnd==0?
                    evnt.endmin = min : evnt.endmin =_MinEnd ;
                    evnt.background = fknclr;
                    var result = rep.insertData("Events", evnt.eventMap());
                    eventsDetails();
                    _EventController.text=" ";
                    Navigator.pop(context, result);
                    eventsDetails();
                  }
                  // }  });
                  // var result=await _userService.deleteUser(userId);
                  // if (result != null) {

                  _showSuccessSnackBar( 'Event added');

                },
                child: const Text('ADD')),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.redAccent),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('CANCEL'))
            ]
          )]));
        });
  }
  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement==CalendarElement.agenda || calendarTapDetails.targetElement==CalendarElement.appointment) {
      final Meeting appointment = calendarTapDetails.appointments![0];
      _selectedAppointment = appointment.eventName;
      print(_selectedAppointment);

    }
  }

  late CalendarTapDetails calendarTapDetails;
  int _page = 0;
  bodyFunction(BuildContext context) {

    switch (_page) {

      case 0:
        return Container(child: SfCalendar(

          showNavigationArrow: true,
          view: CalendarView.day,
          key: ValueKey(CalendarView.day),
          dataSource: MeetingDataSource(_getDataSource()),
          onTap: calendarTapped,


        )
        );
      break;
      case 1:
        return  SfCalendar(
          showNavigationArrow: true,
          view: CalendarView.month,
            key: ValueKey(CalendarView.month),

            dataSource: MeetingDataSource(_getDataSource()),
          monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
          onTap: calendarTapped);

        break;
      case 2:
        return  SfCalendar(
          showNavigationArrow: true,
          view: CalendarView.workWeek,
          key: ValueKey(CalendarView.week),

          showCurrentTimeIndicator: true,
          dataSource: MeetingDataSource(_getDataSource()),
          /* dragAndDropSettings: DayViewState(
              Event.eventType("type", "name"),
        )*/
        );
        break;
    }}
  @override
  Widget build(BuildContext context) {


    int _selectedIndex = 0;
    return  Scaffold(

    bottomNavigationBar: BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.deepPurpleAccent,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white.withOpacity(.60),
    selectedFontSize: 14,
    unselectedFontSize: 14,
    currentIndex: _selectedIndex,
    onTap: (int index) {      setState(
    () {
    _page = index;

    },
    );},
    items: const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
    icon: Icon(Icons.calendar_view_day),
    label: 'Days',
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.calendar_month),
    label: 'Month',
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.calendar_view_week),
    label: 'Week',
    ),
    ],),


    floatingActionButton:  Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [FloatingActionButton(
     // FlatButton(
        child: const Icon(Icons.delete),
        backgroundColor: Colors.red,
        onPressed: () async {
          if (_selectedAppointment != null) {
         //   MeetingDataSource(_getDataSource()).appointments!.removeAt(MeetingDataSource(_getDataSource()).appointments! .indexOf(_selectedAppointment));
            print(_selectedAppointment);
            var ddd= _evntList.where((m) {
              return m.eventName==_selectedAppointment;
            });
            print("heeeeeeeeeeeeeeeeere");
            setState(() {
               //rep.deleteEventById("Events", ddd.first.id);
               deleteFormDialog(context, ddd.first.id);
            eventsDetails();
            });
          //  rep.deleteDataById("Events", _selectedAppointment);
        //    MeetingDataSource(_getDataSource()).notifyListeners(CalendarDataSourceAction.remove, <Meeting>[]..add(_selectedAppointment));
          }
        },
      ),
          const SizedBox(
            width: 100.0,
          ),
          FloatingActionButton(
            backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute( builder: (context) => addreminder()));              //rep.deleteEventById("Events", 4);
              //addevent();
            },
            child: const Icon(Icons.add_alert_outlined),) ,
          const SizedBox(
            width: 100.0,
          ),
    FloatingActionButton(
      backgroundColor: Colors.deepPurpleAccent,
    onPressed: () {
    _AddFormDialog(context);
    //rep.deleteEventById("Events", 4);
    //addevent();
    },
      child: const Icon(Icons.add),)]),

    //),
    body: bodyFunction(context));
  }
  deleteFormDialog(BuildContext context, evntlid) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are You Sure to Delete event or reminder?',
              style: TextStyle(color: Colors.teal, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.red),
                  onPressed: ()  async{

                      var result=await rep.deleteEventById("Events", evntlid);
                      if (result != null) {
                        Navigator.pop(context);
                        eventsDetails();
                        _showSuccessSnackBar(
                            'Event Deleted');
                      }
                    else{ _showSuccessSnackBar(
                        "You can't delete the main category");}},
                  child: const Text('Delete')),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.teal),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }

  List<Meeting> _getDataSource() {

    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
   //  startTime=DateTime.now();
    for(int i=0; i<_evntList.length; i++) {
      var k=DateTime.parse(_evntList[i].startdate as String);
      DateTime startTime = DateTime(k.year, k.month, k.day,
          _evntList[i].starthour as int, _evntList[i].startmin as int, 0);

    final DateTime endTime = startTime.add(const Duration(hours: 2));
      var j=DateTime.parse(_evntList[i].enddate as String);
    final DateTime end = DateTime(j.year, j.month, j.day, _evntList[i].endhour as int, _evntList[i].endmin as int, 0);
    meetings.add(Meeting(_evntList[i].eventName as String, startTime, end, Color(_evntList[i].background as int).withOpacity(0.4) , false));

    }
    return meetings;
  }

}

  class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
  appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
  return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
  return appointments![index].to;
  }

  @override
  String getSubject(int index) {
  return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
  return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
  return appointments![index].isAllDay;
  }
  }

  class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  }


