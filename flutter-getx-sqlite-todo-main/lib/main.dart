import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todo/config/constant.dart';
import 'package:todo/config/routes.dart';
import 'package:todo/views/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,

          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white),          
    );
    return GetMaterialApp(
      title: 'Listyfy - Your Personal Assistant',
      theme: ThemeData(
        splashColor: Colors.blue[50],
        scaffoldBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        primaryColor: Colors.white,
        appBarTheme: const AppBarTheme(          
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: ROUTE_TODO,
      getPages: Routes.routePages,
    );
  }
}
