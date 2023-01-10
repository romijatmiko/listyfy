import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

String generateUuid(){
  var uuid = Uuid();
  return uuid.v4();
}

void showDialog(IconData icon, Color iconColor, String title, String message) {
  Get.dialog(
    AlertDialog(
      title: Column(
        children: [
          Icon(icon, color: iconColor, size: 64),
          SizedBox(height: 16),
          Text(title),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          TextButton(
            child: Text("CLOSE"),
            onPressed: () {
              Get.back();
            },
          )
        ],
      ),
    ),
    barrierDismissible: false,
  );
}

void showSuccess(String title, String message) {
  showDialog(Icons.check_circle, Colors.green, title, message);
}

void showWarning(String title, String message) {
  showDialog(Icons.warning, Colors.amber, title, message);
}

void showError(String title, String message) {
  showDialog(Icons.error, Colors.red, title, message);
}
