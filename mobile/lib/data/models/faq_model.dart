class FaqModel {
  String question;
  String answer;
  FaqModel(this.question, this.answer);
  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(json['question'], json['answer']);
  }
}
