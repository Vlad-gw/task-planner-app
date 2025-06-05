class Task {
  String title;
  String? description;
  int? priority;
  int? creationDate;
  int? finishDate;
  bool? isDone;
  int? timeReminder;
  int? scheduledAt;

  Task({
    required this.title,
    this.description,
    this.priority,
    this.creationDate,
    this.finishDate,
    this.isDone = false,
    this.timeReminder,
    this.scheduledAt,
  });


  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(title: json['title'],
        description: json['description'],
        priority: json['priority'],
        creationDate: json['creationDate'],
        finishDate: json['finishDate'],
        isDone: json['isDone'],
        timeReminder: json['timeReminder'],
        scheduledAt: json['scheduledAt']);
  }
}
