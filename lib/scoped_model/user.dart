import 'package:scoped_model/scoped_model.dart';

import '../models/user.dart';

abstract class UserModel extends Model{
  User _authenticateUser;

  void login(String email,String password){
    _authenticateUser = User(id: '12345', email: email, password: password);
  }
}