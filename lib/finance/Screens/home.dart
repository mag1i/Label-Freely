
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:labelfreely/finance/Screens/add.dart';
import 'package:labelfreely/finance/Screens/statistics.dart';
import 'package:labelfreely/finance/data/model/add_date.dart';
import 'package:labelfreely/finance/data/utility.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../drawer.dart';
import '../../widgets/Add/Addcategpry.dart';
import '../../widgets/Add/Addreminder.dart';
import '../widget/Help.dart';
import '../../main.dart';
import '../../organized.dart';
import '../../percentage.dart';
import '../../reminder.dart';
import '../../todo.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var history;
  final box = Hive.box<Add_data>('data');
  final List<String> day = [
    'Monday',
    "Tuesday",
    "Wednesday",
    "Thursday",
    'friday',
    'saturday',
    'sunday'
  ];
  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  _deleteFormDialog(BuildContext context, lblid) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are You Sure to Delete this money change state',
              style: TextStyle(color: Colors.teal, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.red),
                  onPressed: ()  async{
                    setState(() {
                      var result= lblid.delete();
                      if (result != null) {
                        Navigator.pop(context);
                        _showSuccessSnackBar(
                            'Money change state caategoty Deleted Success');
                      }
                    });



                    },
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
  drawer d = drawer();
  @override
  Widget build(BuildContext context) {
    int _selectedIndex=0;
    return Scaffold(
      drawer: d.drwer(context),

      appBar: AppBar(
        title: const Text("Wallet"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      floatingActionButton: Container(
          decoration: BoxDecoration(
         //   color:  Colors.white,
            borderRadius: BorderRadius.all( Radius.circular(50.0)),
            border: Border.all(
            //  color: Colors.white,
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
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Add_Screen()));
              break;
            case 3:
            //  rep.deleteDataById("cont",  _userList.last.id);
              Navigator.push(context,  MaterialPageRoute(builder: (context) =>  Statistics())) ;

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
            label: 'Add finance',
            icon: Icon(Icons.add_task_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'statistics',
            icon: Icon(Icons.stacked_bar_chart),
          ),
          BottomNavigationBarItem(

            label: 'Back',
            icon: Icon(Icons.arrow_back),

          ),

        ],
      ),
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, value, child) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(height: 340, child: _head()),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Transactions History',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 19,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'See all',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          history = box.values.toList()[index];
                          return getList(history, index);
                        },
                        childCount: box.length,
                      ),
                    )
                  ],
                );
              })),
    );
  }

  Widget getList(Add_data history, int index) {
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          history.delete();
        },
        child: get(index, history));
  }

  ListTile get(int index, Add_data history) {
    return ListTile(
      onLongPress:(){ setState(() {
        _deleteFormDialog( context, history);
      });},
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset('images/${history.name}.png', height: 40),
      ),
      title: Text(
        (history.name)+"  "+(history.explain),
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${day[history.datetime.weekday - 1]}  ${history.datetime.year}-${history.datetime.day}-${history.datetime.month}',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        history.amount,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 19,
          color: history.IN == 'Income' ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  Widget _head() {
    return Stack(

      children: [
        Column(

          children: [
            Container(

              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
             //   color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
               /*   Positioned(
                    top: 35,
                    left: 340,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: Color.fromRGBO(250, 250, 250, 0.1),
                        child: Icon(
                          Icons.notification_add_outlined,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),*/
                  Padding(

                    padding: const EdgeInsets.only(top: 20, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          '                 Manage your wallet ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        SizedBox(height: 20,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(

                            // primary: pickerColor,
                              backgroundColor: Color(0xFF7986CB),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              padding: const EdgeInsets.only(
                                  left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
                          child:const Text('Check statistics'),
                          onPressed: (() {
                            Navigator.push(context, MaterialPageRoute(builder:(context)=> Statistics()));
                          }),
                        )

                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 140,
          left: 37,
          child: Container(
            height: 170,
            width: 320,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  //color: Color.fromRGBO(47, 125, 121, 0.3),
                  color: Colors.deepPurple,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
             // color: Color.fromARGB(255, 47, 125, 121),
              color: Color(0xFF7986CB),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        '\$ ${total()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            //backgroundColor: Color.fromARGB(255, 85, 145, 141),
                            backgroundColor: Colors.deepPurple,
                            child: Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Income',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                           // backgroundColor: Color.fromARGB(255, 85, 145, 141),
                            backgroundColor: Colors.deepPurple,
                            child: Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Expenses',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$ ${income()}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '\$ ${expenses()}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}