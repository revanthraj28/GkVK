import 'package:get/get.dart';
import 'package:gkvk/models/user_model.dart';

class UserController extends GetxController {

  final _isEdited = false.obs; //Observables
  get isEdited => _isEdited.value;

  final _user = UserModel().obs; //Observables
  get user => _user.value;

  mEditForm() {
    _isEdited.value = !_isEdited.value;
  } //Method to edit

  mUser(UserModel user) {
    _user.value = user;
  }//Method to update

  mUsername(String username) {
    UserModel user = _user.value;
    user.username = username;
  } //Method to update

  mAge(String age) {
    UserModel user = _user.value;
    user.age = age;
  } //Method to update

  initUser() async {
    UserModel user = await UserModel.getCurrentUser();
    mUser(user);
  } //Method to initialize

//Lifecycle
}

