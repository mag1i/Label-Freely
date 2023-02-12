import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:labelfreely/finance/data/utility.dart';
import 'package:labelfreely/finance/widget/chart.dart';

import '../../widgets/Add/Addreminder.dart';
import '../../main.dart';
import '../data/model/add_date.dart';
import '../data/top.dart';
import 'add.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

ValueNotifier kj = ValueNotifier(0);

class _StatisticsState extends State<Statistics> {
  List day = ['Day', 'Week', 'Month', 'Year'];
  List f = [today(), week(), month(), year()];
  List<Add_data> a = [];
  int index_color = 0;

  @override
  Widget build(BuildContext context) {
    int _selectedIndex=0;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Financial Statistics"),
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

      )]),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: kj,
          builder: (BuildContext context, dynamic value, Widget? child) {
            a = f[value];
            return custom();
          },
        ),
      ),
    );
  }
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
            var result = lblid.delete();
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
  CustomScrollView custom() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'Statistics',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(
                      4,
                          (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              index_color = index;
                              kj.value = index;
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index_color == index
                                //  ? Color.fromARGB(255, 47, 125, 121)
                                  ? Colors.deepPurpleAccent
                                  : Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              day[index],
                              style: TextStyle(
                                color: index_color == index
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Chart(
                indexx: index_color,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Spending',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.swap_vert,
                      size: 25,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return ListTile(
                  onLongPress: (){setState(() {
                    _deleteFormDialog(context, a[index]);
                  }); },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset('images/${a[index].name}.png', height: 40),
                  ),
                  title: Text(
                    a[index].name,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    ' ${a[index].datetime.year}-${a[index].datetime.day}-${a[index].datetime.month}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing:
                  /*Container(
                    //padding: EdgeInsets.fromLTRB(-20, 1, 1, 1),

                      width: 40,
                      child:Column( children:[
                    IconButton(
                        icon: Icon(Icons.delete, size: 20,),
                      onPressed:(){
                          //a.remove( a[index]);
                         // a.removeAt(index);
                      a[index].delete();
                          },
                    ),*/
                    Text(
                    a[index].amount,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: a[index].IN == 'Income' ? Colors.green : Colors.red,
                    ),
                  ),
             //     ]))
                );
              },
              childCount: a.length,
            ))
      ],
    );
  }
}