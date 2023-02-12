
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:labelfreely/Models/Category.dart';

import 'package:labelfreely/database/servicescnt.dart';

import '../../database/repository.dart';
class EditCategory extends StatefulWidget {
  final Categor ct;
  const EditCategory({Key? key,required this.ct}) : super(key: key);

  @override
  State<EditCategory> createState() => _EditCategoryrState();
}

class _EditCategoryrState extends State<EditCategory> {
  var _ctNameController = TextEditingController();
  var _ClrController;
  bool _validateName = false;

  var rep =Repository();
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Color pickerColor = const Color(0xff2196f3);
  Color currentColor = const Color(0xff443a49);


  @override
  void initState() {
    setState(() {
      _ctNameController.text=widget.ct.namec??'';
      _ClrController=widget.ct.colorlbl;

    });
    super.initState();
  }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Category"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _ctNameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Name',
                    labelText: 'Name',
                    errorText:
                    _validateName ? 'Name Value Can\'t Be Empty' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: pickerColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)),
                    padding: const EdgeInsets.only(
                        left: 30.0, top: 0.0, right: 30.0, bottom: 0.0)),
                onPressed: (() {
                  colorPickerDialog();
                }),
                child: const Text('PICK COLOR'),
              ),
              const SizedBox(
                height: 20.0,
              ),

              Row(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.teal,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () async {
                        setState(() {
                          _ctNameController.text.isEmpty
                              ? _validateName = true
                              : _validateName = false;

                        });
                        if (_validateName == false) {
                          // print("Good Data Can Save");
                          var _user = Categor();
                          _user.idc=widget.ct.idc;
                          _user.namec = _ctNameController.text;
                          _user.colorlbl = colorCodeInt as int?;

                          var result=await rep.updateCat("Label", _user.lblMap()!);
                          Navigator.pop(context,result);
                        }
                      },
                      child: const Text('Edit')),
                  const SizedBox(
                    width: 10.0,
                  ),


                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () {
                        _ctNameController.text = '';

                      },
                      child: const Text('Clear '))
                ],
              ),

            ],
          ),
        ),
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
              Navigator.of(context).pop(false);
            },
            child: const Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}