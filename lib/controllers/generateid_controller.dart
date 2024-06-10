import 'package:get/get.dart';

class GenerateidController extends GetxController {
  // Private observable
  final _pagenumber = 0.obs;

  // Getter for the current page number
  int get pagenumber => _pagenumber.value;

  // Setter for the page number
  set pagenumber(int index) => _pagenumber.value = index;

  // Method to increment the page number
  void incrementPageNumber() {
    _pagenumber.value++;
  }

  // Method to decrement the page number
  void decrementPageNumber() {
    if (_pagenumber.value > 0) { // Ensure it doesn't go below 0
      _pagenumber.value--;
    }
  }
}
