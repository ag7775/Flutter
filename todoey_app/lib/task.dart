class Task {
  String task;
  bool isDone;

  Task({this.task, this.isDone = false});

  void toggleIsDone() {
    isDone = !isDone;
  }
}
