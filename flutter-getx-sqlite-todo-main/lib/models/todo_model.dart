class TodoModel {
  final String uuid;
  final String title;
  final String description;
  final int timestamp;
  final bool isDone;
  final String priority;
  final bool isArchived;

  TodoModel(
      {required this.uuid,
      required this.title,
      required this.timestamp,
      required this.isDone,
      required this.priority,
      required this.description,
      required this.isArchived});

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'title': title,
      'description': description,
      'timestamp': timestamp,
      'isDone': isDone,
      'priority': priority,
      'isArchived' : isArchived
    };
  }
}
