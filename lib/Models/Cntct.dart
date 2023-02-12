import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';


class Cntct{
   String? id;
   String? name;
   String? number;
   String? image;
   String?  note;
   String? email;
   int? label;
   userMap() {
      var mapping = Map<String, dynamic>();
      mapping['id'] = id!;
      mapping['name'] = name!;
      mapping['number'] = number ?? null;
      mapping['image'] = image ?? "ss";
      mapping['note'] = note!;
      mapping['email'] = email!;
      mapping['idlbl'] = label!;

      return mapping;
   }

  /*
  const Cntct({
    required this.name, required this.number, required this.image,    required this.note, required  this.email, required  this.label,  required  this.labelcolor,

  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
      'image': image,
       'note': note,
    'email':email,
    'label':label,
    'labelcolor':labelcolor,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Cnt{name: $name, number: $number, image: $image, note: $note, email: $email, label: $label, labelcolor: $labelcolor}';
  }

*/

  /*Cntct(String name, String numver, Image image, String note, String email, String label, Color labelcolor){
    this.number=number;
    this.name=name;
    this.image=image;
    this.note= note;
    this.email=email;
    this.label=label;
    this.labelcolor;
  }*/
}