import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/controllers/todo_controller.dart';
import 'package:todo/models/todo_model.dart';

class TodoDetailView extends StatelessWidget {
  TodoDetailView({Key? key}) : super(key: key);

  TodoController todoController = Get.find<TodoController>();

  @override
  Widget build(BuildContext context) {
    TodoModel todoModel = todoController.todoModel.value;
    return Scaffold(
      appBar: AppBar(
        title: Text(todoController.titleTodoDetail.value),
      ),
      body: SafeArea(
        child: Obx(() => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: todoController.titleController,
                      minLines: 1,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 24),
                      decoration: const InputDecoration(
                        labelText: "Judul",
                        labelStyle:
                            TextStyle(fontSize: 24, color: Colors.black45),
                        border: InputBorder.none,
                      ),
                    ),
                    TextFormField(
                      controller: todoController.descriptionController,
                      minLines: 10,
                      maxLines: 500,
                      decoration: const InputDecoration(
                        labelText: "Deskripsi List",
                        labelStyle: TextStyle(color: Colors.black45),
                        alignLabelWithHint: true,
                        border: InputBorder.none,
                      ),
                    ),
                    const Text(
                      "Prioritas",
                      style: TextStyle(color: Colors.black45),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  todoController.selectedPriority.value != "low"
                                      ? Colors.white
                                      : Colors.green),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              todoController.setSelectedPriority("low");
                            },
                            child: Text(
                              "Low",
                              style: TextStyle(
                                  color:
                                      todoController.selectedPriority.value ==
                                              "low"
                                          ? Colors.white
                                          : Colors.green),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  todoController.selectedPriority.value !=
                                          "normal"
                                      ? Colors.white
                                      : Colors.blue),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              todoController.setSelectedPriority("normal");
                            },
                            child: Text(
                              "Normal",
                              style: TextStyle(
                                  color:
                                      todoController.selectedPriority.value ==
                                              "normal"
                                          ? Colors.white
                                          : Colors.blue),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  todoController.selectedPriority.value !=
                                          "high"
                                      ? Colors.white
                                      : Colors.orange),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              todoController.setSelectedPriority("high");
                            },
                            child: Text(
                              "High",
                              style: TextStyle(
                                  color:
                                      todoController.selectedPriority.value ==
                                              "high"
                                          ? Colors.white
                                          : Colors.orange),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  todoController.selectedPriority.value !=
                                          "urgent"
                                      ? Colors.white
                                      : Colors.red),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              todoController.setSelectedPriority("urgent");
                            },
                            child: Text(
                              "Urgent",
                              style: TextStyle(
                                  color:
                                      todoController.selectedPriority.value ==
                                              "urgent"
                                          ? Colors.white
                                          : Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Deadline",
                      style: TextStyle(color: Colors.black45),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        InkWell(
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: Colors.blue, width: 1)
                            ),
                            child: Text(
                              todoController.convertDateToDateString(
                                  todoController.selectedDate.value, "dd MMM yyyy"),
                            ),
                          ),
                          onTap: (){
                            todoController.chooseDate(context);
                          },
                        ),
                    const SizedBox(width: 8),
                        InkWell(
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: Colors.blue, width: 1)
                            ),
                            child: Text(
                              todoController.convertTimeToTimeString(
                                  todoController.selectedTime.value, "dd MMM yyyy"),
                            ),
                          ),
                          onTap: (){
                            todoController.chooseTime(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48.0),
                          ),
                        ),
                        onPressed: () {
                          todoController.saveTodo();
                        },
                        icon: const Icon(Icons.save),
                        label: Text(todoController.showButtonDelete.value
                            ? "Update List Sekarang"
                            : "Simpan List Sekarang"),
                      ),
                    ),
                    (todoController.showButtonDelete.value)
                        ? SizedBox(
                            width: double.maxFinite,
                            child: OutlinedButton.icon(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(48.0),
                                ),
                              ),
                              onPressed: () {
                                todoController.deleteTodo(todoModel.uuid);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              label: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
