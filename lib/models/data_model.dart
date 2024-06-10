
class Question {
  String questionText;
  List<String> options;
  String selectedOption;

  Question({required this.questionText, required this.options, this.selectedOption = ''});
}
