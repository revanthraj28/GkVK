import 'package:get/get.dart';
class TabIndexController extends GetxController {
  final _selectedBodyIndex = 0.obs;
  int get selectedBodyIndex => _selectedBodyIndex.value;
  set selectedBodyIndex(int index) => _selectedBodyIndex.value = index;
}