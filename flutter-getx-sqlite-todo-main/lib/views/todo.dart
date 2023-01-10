import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todo/config/constant.dart';
import 'package:todo/controllers/todo_controller.dart';
import 'package:todo/models/todo_model.dart';

class TodoView extends StatelessWidget {
  TodoView({Key? key}) : super(key: key);

  TodoController todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listyfy - Aplikasi Catatan"),
      ),
      body: SafeArea(
        child: GetX<TodoController>(
          builder: (controller) {
            if (controller.loading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // if (controller.todoList.isEmpty) {
            //   return const Center(
            //     child: Text("No Data."),
            //   );
            // }

            return Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 8),
                      OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              todoController.selectedFilterStatus.value !=
                                      "active"
                                  ? Colors.white
                                  : Colors.blue),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          todoController.setFilter("active");
                        },
                        child: Text(
                          "Active",
                          style: TextStyle(
                              color:
                                  todoController.selectedFilterStatus.value ==
                                          "active"
                                      ? Colors.white
                                      : Colors.blue),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              todoController.selectedFilterStatus.value !=
                                      "expired"
                                  ? Colors.white
                                  : Colors.red),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          todoController.setFilter("expired");
                        },
                        child: Text(
                          "Expired",
                          style: TextStyle(
                              color:
                                  todoController.selectedFilterStatus.value ==
                                          "expired"
                                      ? Colors.white
                                      : Colors.red),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                (controller.todoList.isEmpty)
                    ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 50.0),
                      child: Center(
                          child: Text("No Data."),
                        ),
                    )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: controller.todoList.length,
                          itemBuilder: ((context, index) {
                            TodoModel todoModel = controller.todoList[index];

                            String date =
                                controller.convertTimestampToDateString(
                                    todoModel.timestamp, "dd MMM yy HH:mm");
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black12,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(todoModel.title),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Created $date"),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 8,
                                            top: 4,
                                            right: 8,
                                            bottom: 4),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            border: Border.all(
                                                color: todoController
                                                    .generateColorForPriority(
                                                  todoModel.priority
                                                      .toLowerCase(),
                                                ),
                                                width: 1)),
                                        child: Text(
                                          todoModel.priority
                                              .toString()
                                              .toUpperCase(),
                                          style: TextStyle(
                                              color: todoController
                                                  .generateColorForPriority(
                                                      todoModel.priority
                                                          .toLowerCase()),
                                              fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    todoController
                                        .goToTodoDetail(todoModel.uuid);
                                  },
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          todoController.goToTodoDetail('');
        },
      ),
    );
  }
}
