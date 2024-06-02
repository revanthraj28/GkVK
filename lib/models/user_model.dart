import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:gkvk/constants/key.dart';

class UserModel{
  String id;
  String username;
  String age;

  // Making mockupUserData static because it's used in a static method
  static String mokupUserData = "{\"id\":\"001\",\"username\":\"SETA\",\"age\":\"18\"}";

  // Default constructor with optional named parameters and initial values
  UserModel({this.id = '', this.username = '', this.age = ''});

  // Named constructor for creating a UserModel instance from a JSON map
  UserModel.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'].toString(),
        username = json['username'].toString(),
        age = json['age'].toString();
  // Static method to get the current user
  static getCurrentUser() {
    GetStorage storage = GetStorage();
    // Reading the user string from storage or using the mockup data
    String userString = storage.read(KeyConst.TOKEN_STORE_KEY) ?? mokupUserData;
    if (userString != "") {
      Map data = json.decode(userString.toString());
      return UserModel.fromJson(data);
    } else {
      print("empty user");
      return UserModel();
    }
  }
}