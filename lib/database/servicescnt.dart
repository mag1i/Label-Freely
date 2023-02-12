
import 'package:labelfreely/database/repository.dart';

import '../Models/Category.dart';
import '../Models/Cntct.dart';


class UserService
{
  late Repository _repository;
  UserService(){
    _repository = Repository();
  }
  //Save User
  SaveUser(Cntct user) async{
    return await _repository.insertData('cont', user.userMap());
  }
  SaveCategory(Categor ctg) async{
    return await _repository.insertData('Label', ctg.lblMap());
  }
  //Read All Users
  readAllUsers() async{
    return await _repository.readData('cont');
  }
  readAllCategories() async{
    return await _repository.readData('Label');
  }
  //Edit User
  UpdateUser(Cntct user) async{
    return await _repository.updateData('cont', user.userMap());
  }

  deleteUser(userId) async {
    return await _repository.deleteDataById('cont', userId);
  }
  deletecat(ctg) async {
    return await _repository.deletectgrById('Label', ctg);
  }

}