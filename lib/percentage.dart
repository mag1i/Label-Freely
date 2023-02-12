import 'package:labelfreely/todo.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';

import 'widgets/Add/AddLabel.dart';
import 'database/repository.dart';

class percentage extends StatefulWidget {
  const percentage({Key? key}) : super(key: key);

  @override
  State<percentage> createState() => _percentageState();
}

class _percentageState extends State<percentage> {
  Repository rep= Repository();
  late List<Todo> _todoList = <Todo>[];
  getAlltodoDetails() async {
    var todos = await rep.readData("Todos");
    _todoList = <Todo>[];
    todos.forEach((user) {
      setState(() {
        var userModel = Todo();
        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.idlbl = user['idlbl'];
        userModel.checked = user['checked'];
        userModel.date = user['date'];
        _todoList.add(userModel);
      });
    });}
  late List<Todo> _todocheck = <Todo>[];
  getcheckedtodo() async {
    var todos = await rep.readDataBycheck("Todos");
    _todocheck = <Todo>[];
    todos.forEach((user) {
      setState(() {
        var userodel = Todo();
        userodel.id = user['id'];
        userodel.name = user['name'];
        userodel.idlbl = user['idlbl'];
        userodel.checked = user['checked'];
        userodel.date = user['date'];
        _todocheck.add(userodel);
      });
    });}
  late List<Label> _ctgrList = <Label>[];
  getAllLabelDetails() async {
    var users = await rep.readData("Labelnotes");
    _ctgrList = <Label>[];
    users.forEach((user) {
      setState(() {
        var userModel = Label();
        userModel.idc = user['idlabel'];
        userModel.namec = user['namelabel'];
        userModel.colorlbl = user['colorlabel'];

        _ctgrList.add(userModel);
      });
    });
  }
  late List<Todo> _checkedbycatList = <Todo>[];
  get_checkedbycatList(g) async {
    var users = await rep.readDataBycheckcat("Todos", g);
    _checkedbycatList = <Todo>[];
    users.forEach((user) {
      if (this.mounted) {
      setState(() {
        var userodel = Todo();
        userodel.id = user['id'];
        userodel.name = user['name'];
        userodel.idlbl = user['idlbl'];
        userodel.checked = user['checked'];
        userodel.date = user['date'];

        _checkedbycatList.add(userodel);
      });}
    });
  }
  late List<Todo> databycat = <Todo>[];
  getdatabycat(g) async {
    var users = await rep.readDataByCategory("Todos", g);
    databycat = <Todo>[];
    users.forEach((user) {
      if (this.mounted) {
      setState(() {
        var userodel = Todo();
        userodel.id = user['id'];
        userodel.name = user['name'];
        userodel.idlbl = user['idlbl'];
        userodel.checked = user['checked'];
        userodel.date = user['date'];

        databycat.add(userodel);
      });}
    });
  }
 late double scor;
  void initState() {
    super.initState();

    getcheckedtodo();
    getAlltodoDetails();
    getAllLabelDetails();



  }
 @override
    Widget build(BuildContext context) {
   scor=  _todocheck.length/_todoList.length;
   print(scor.toString());
      return Scaffold(
        appBar: new AppBar(
          title: new Text("Todo list progress percentage"),
          backgroundColor:  Colors.deepPurpleAccent,
        ),


        body: Container(
          decoration: BoxDecoration(image:DecorationImage(fit: BoxFit.fill, image:AssetImage("images/prog.png")) ),
          child: ListView(
              children: <Widget>[

SizedBox(height: 200,),
                new CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 13.0,
                  animationDuration: 1200,
                  animation: true,
                  percent:scor,
                  center: new Text(
                    ( (scor*100).toString().substring(0,3))+"%",
                    style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  footer: new Text(
                    "Your progress",
                    style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.deepPurpleAccent,
                ),


   SingleChildScrollView(
   //scrollDirection: Axis.vertical,
   child:Column(

   mainAxisAlignment: MainAxisAlignment.center,
   mainAxisSize: MainAxisSize.max,
   //  mainAxisSize: MainAxisSize.min,
   children: <Widget>[
     Text("\n\nPregress by gategory: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),),
   //    SizedBox(height: 150,),
   Container(

   margin: const EdgeInsets.symmetric(vertical: 20.0),
   height: 200.0,
   child:
   ListView.builder(

   shrinkWrap: true,
   scrollDirection: Axis.horizontal,

   padding: EdgeInsets.fromLTRB(10, 0, 5, 1),
   //scrollDirection: Axis.v
   itemCount: _ctgrList.length,
   itemBuilder: (context, index) {
   if (mounted) {
    // getdatabycat(_ctgrList[index].idc);
    // get_checkedbycatList(_ctgrList[index].idc);
   }
   var ddd=_todoList.where((m) {
     return m.idlbl==_ctgrList[index].idc;
   });
   late var d;
   late var h;
   if(ddd.isNotEmpty){
    d = ddd.where((element) => element.checked==1 );
    h= d.length*100/ddd.length;} else{print("k");}
  return SingleChildScrollView( child: Container(
   width: 170.0,
   height: 200,
   child: Container( child :CircularPercentIndicator(
   radius: 45.0,
   lineWidth: 4.0,
   percent: h/100,
   center:  Text((h.toString().substring(0,3))+"%"),

   progressColor: _ctgrList[index].idc==1? Colors.black54: Color(_ctgrList[index].colorlbl as int),
     footer: new Text(
       _ctgrList[index].namec as String,
       style:
       new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
     ),
   ))));})
                  /* Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                       CircularPercentIndicator(
                        radius: 45.0,
                        lineWidth: 4.0,
                        percent: 0.10,
                        center:  Text("10%"),
                        progressColor: Colors.red,
                      ),
                       Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                       CircularPercentIndicator(
                        radius: 45.0,
                        lineWidth: 4.0,
                        percent: 0.30,
                        center:  Text("30%"),
                        progressColor: Colors.orange,
                      ),
                      new Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      new CircularPercentIndicator(
                        radius: 45.0,
                        lineWidth: 4.0,
                        percent: 0.60,
                        center: new Text("60%"),
                        progressColor: Colors.yellow,
                      ),
                      new Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      new CircularPercentIndicator(
                        radius: 45.0,
                        lineWidth: 4.0,
                        percent: 0.90,
                        center: new Text("90%"),
                        progressColor: Colors.green,
                      )
                    ],
                  ),*/

              ,
        ),
     ]) )])));
    }
  }

