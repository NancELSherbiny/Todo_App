import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../FireBaseUtils.dart';
import '../model/task.dart';

class AppConfigProvider extends ChangeNotifier {
  String appLanguage = 'en';
  ThemeMode appTheme = ThemeMode.dark;
  List<Task> tasksList = [];
  DateTime selectedDate = DateTime.now();
  Task? task;

  void changeLanguage(String newLanguage) {
    if (appLanguage == newLanguage) {
      return;
    }
    appLanguage = newLanguage;
    notifyListeners();
  }

  void changeTheme(ThemeMode newMode) {
    if (appTheme == newMode) {
      return;
    }
    appTheme = newMode;
    notifyListeners();
  }

  bool isDarkMode() {
    return appTheme == ThemeMode.dark;
  }

  void changeToDone() {
    task?.isDone == true;
    notifyListeners();
  }

  bool done() {
    return task?.isDone == true;
  }

  void getAllTasksFromFireStore(String uId) async {
    QuerySnapshot<Task> querySnapshot =
        await FireBaseUtils.getTasksCollection(uId).get();
    tasksList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();

    tasksList = tasksList.where((task) {
      if (task.dateTime!.day == selectedDate.day &&
          task.dateTime!.month == selectedDate.month &&
          task.dateTime!.year == selectedDate.year) {
        return true;
      }
      return false;
    }).toList();

    tasksList.sort((Task task1, Task task2) {
      return task1.dateTime!.compareTo(task2.dateTime!);
    });

    notifyListeners();
  }

  void changeSelectedDate(DateTime newDate, String uId) {
    selectedDate = newDate;
    getAllTasksFromFireStore(uId);
    notifyListeners();
  }
}
