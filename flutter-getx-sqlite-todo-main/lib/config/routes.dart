import 'package:get/get.dart';
import 'package:todo/config/constant.dart';
import 'package:todo/views/todo.dart';
import 'package:todo/views/todo_detail.dart';

class Routes {
  static final routePages = [
    GetPage(name: ROUTE_TODO, page: () => TodoView()),
    GetPage(
      name: ROUTE_TODO_DETAIL,
      page: () => TodoDetailView(),
      transition: Transition.leftToRight
    )
  ];
}
