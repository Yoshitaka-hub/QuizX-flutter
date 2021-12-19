class Question {
  late String url;
  late String question;
  late String answer;
  late String explanation;
  Question(this.url, this.question, this.answer, this.explanation);

  Question.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        question = json['question'],
        answer = json['answer'],
        explanation = json['explanation'];

  Map<String, dynamic> toJson() => {
        'url': url,
        'question': question,
        'answer': answer,
        'explanation': explanation
      };
}
