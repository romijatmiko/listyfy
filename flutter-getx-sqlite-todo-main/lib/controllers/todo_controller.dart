import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/config/constant.dart';
import 'package:todo/database/database_helper.dart';
import 'package:todo/models/todo_model.dart';

class TodoController extends GetxController {
  RxBool loading = false.obs;
  RxBool showButtonDelete = false.obs;
  RxString titleTodoDetail = "New ToDo".obs;
  Rx<TodoModel> todoModel = TodoModel(
          uuid: '',
          title: '',
          timestamp: 0,
          isDone: false,
          priority: '',
          description: '',
          isArchived: false)
      .obs;
  RxList<TodoModel> todoList = <TodoModel>[].obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  RxString selectedFilterStatus = "active".obs;
  RxString selectedPriority = "low".obs;
  var selectedDate = DateTime.now().obs;
  var selectedTime = TimeOfDay.now().obs;

  bool get archivedStatus => todoModel.value.isArchived;
  bool get doneStatus => todoModel.value.isDone;

  @override
  void onInit() {
    getAll();
    super.onInit();
  }

  void getAll() async {
    try {
      loading(true);
      List<TodoModel> list = await DatabaseHelper.instance.todoGetList();
      todoList.clear();
      for (var row in list) {
        todoList.add(row);
      }
      loading(false);
    } finally {
      loading(false);
    }
  }

  setFilter(String filter) async{
    selectedFilterStatus(filter);
    try {
      loading(true);
      List<TodoModel> list = await DatabaseHelper.instance.todoGetListForStatus(filter);
      todoList.clear();
      for (var row in list) {
        todoList.add(row);
      }
      loading(false);
    } finally {
      loading(false);
    }
  }

  goToTodoDetail(String uuid) async {
    TodoModel curr = await DatabaseHelper.instance.todoGet(uuid);

    showButtonDelete(false);
    titleTodoDetail("New ToDo");
    selectedPriority("low");
    selectedDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
    selectedTime(TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0));

    if (curr.uuid.isNotEmpty) {
      todoModel(curr);

      showButtonDelete(true);
      titleTodoDetail("Edit ToDo");

      titleController.text = todoModel.value.title;
      descriptionController.text = todoModel.value.description;

      selectedPriority(todoModel.value.priority);

      int timestamp = todoModel.value.timestamp;

      DateTime datetime = DateTime.fromMillisecondsSinceEpoch(timestamp);

      selectedDate(datetime);
      selectedTime(TimeOfDay.fromDateTime(datetime));
    } else {
      titleController.clear();
      descriptionController.clear();
      todoModel(curr);
    }

    Get.toNamed(ROUTE_TODO_DETAIL);
  }

  saveTodo() async {
    String selectedDatetime =
        convertDateToDateString(selectedDate.value, "yyyy-MM-dd");

    int hour = selectedTime.value.hour;
    String hourText = hour.toString();
    if (hour < 10) hourText = "0$hourText";

    int minute = selectedTime.value.minute;
    String minuteText = minute.toString();
    if (minute < 10) minuteText = "0$minuteText";

    selectedDatetime += " $hourText:$minuteText:00";

    DateTime deadlineDatetime = DateTime.parse(selectedDatetime);
    double timestampD = deadlineDatetime.millisecondsSinceEpoch / 1000;
    int timestamp = deadlineDatetime.millisecondsSinceEpoch;

    try {
      String title = titleController.text;
      String description = descriptionController.text;

      if (title.isEmpty) {
        Get.snackbar("Failed", "Title must have value",
                backgroundColor: Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM)
            .show();
        return;
      }

      loading(true);

      TodoModel current = TodoModel(
          uuid: todoModel.value.uuid,
          title: title,
          timestamp: timestamp,
          isDone: false,
          isArchived: false,
          priority: selectedPriority.value,
          description: description);

      if (todoModel.value.uuid.isEmpty) {
        String uuid = await DatabaseHelper.instance.todoInsert(current);
        if (uuid.isNotEmpty) {
          titleController.clear();
          descriptionController.clear();

          getAll();
          Get.back(result: true);
        } else {
          Get.snackbar("Failed", "Cannot create new todo",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM)
              .show();
        }
      } else {
        String res = await DatabaseHelper.instance
            .todoUpdate(todoModel.value.uuid, current);
        if (res.isNotEmpty) {
          titleController.clear();
          descriptionController.clear();

          getAll();
          Get.back(result: true);
        } else {
          Get.snackbar("Failed", "Cannot update existing todo",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM)
              .show();
        }
      }
    } finally {
      loading(false);
    }
  }

  deleteTodo(uuid) async {
    TodoModel curr = await DatabaseHelper.instance.todoGet(uuid);
    if (curr.uuid.isEmpty) {
      Get.snackbar("Failed", "Unknown todo",
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM)
          .show();
      getAll();
      return;
    }

    int res = await DatabaseHelper.instance.todoDelete(uuid);
    if (res > 0) {
      getAll();
      Get.back(result: true);
    } else {
      Get.snackbar("Failed", "Cannot delete todo",
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM)
          .show();
    }
  }

  String convertTimestampToDateString(int timestamp, String format) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat(format).format(date);
  }

  String convertDateToDateString(DateTime dateTime, String format) {
    return DateFormat(format).format(dateTime);
  }

  String convertTimeToTimeString(TimeOfDay timeOfDay, String format) {
    String time = "";

    int hour = timeOfDay.hour;
    String hourText = hour < 10 ? "0$hour" : "$hour";

    int minute = timeOfDay.minute;
    String minuteText = minute < 10 ? "0$minute" : "$minute";

    return "$hourText:$minuteText";
  }

  Color generateColorForPriority(String prioriy) {
    Color color = Colors.blue;
    switch (prioriy) {
      case 'low':
        color = Colors.green;
        break;
      case 'normal':
        color = Colors.blue;
        break;
      case 'high':
        color = Colors.orange;
        break;
      case 'urgent':
        color = Colors.red;
        break;
      default:
    }

    return color;
  }

  setSelectedPriority(String priority) {
    selectedPriority(priority);
  }

  setSelectedFilterStatus(String status) {
    selectedFilterStatus(status);
  }

  chooseDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        firstDate: DateTime.now().subtract(Duration(days: 30)),
        lastDate: DateTime(DateTime.now().year + 1),
        initialDatePickerMode: DatePickerMode.day);

    if (picked != null) {
      selectedDate(picked);
    }
  }

  chooseTime(BuildContext context) async {
    TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: selectedTime.value);

    if (picked != null) {
      selectedTime(picked);
    }
  }
}
