import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/Dialog_utils/dialog_utils.dart';
import 'package:todo/FireBaseUtils.dart';
import 'package:todo/mytheme.dart';
import 'package:todo/provider/app_config_provider.dart';
import 'package:todo/provider/auth_provider.dart';

import '../../model/task.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  DateTime selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  late AppConfigProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Text('Add new Task',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: MyTheme.blackColor)),
          Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (text) {
                        title = text;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter task title';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Task title',
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (text) {
                        description = text;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter task description';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Task description',
                      ),
                      maxLines: 4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'select date',
                      style: provider.isDarkMode()
                          ? TextStyle(color: MyTheme.greyColor, fontSize: 22)
                          : Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showCalendar();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        textAlign: TextAlign.center,
                        style: provider.isDarkMode()
                            ? TextStyle(color: MyTheme.greyColor, fontSize: 22)
                            : Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        addTask();
                      },
                      child: Text(
                        'Add',
                        style: Theme.of(context).textTheme.titleLarge,
                      ))
                ],
              ))
        ],
      ),
    );
  }

  void showCalendar() async {
    var chooseDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (chooseDate != null) {
      selectedDate = chooseDate;
    }
    setState(() {});
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      ///add task to firebase
      Task task =
          Task(title: title, description: description, dateTime: selectedDate);

      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      FireBaseUtils.addTaskToFireStore(task, authProvider.currentUser?.id ?? "")
          .then((value) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, 'Task added successfully!!',
            positiveActionName: 'ok', positiveAction: () {
          Navigator.pop(context);
        });
      }).timeout(Duration(milliseconds: 500), onTimeout: () {
        Fluttertoast.showToast(
            msg: "Task added successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        provider.getAllTasksFromFireStore(authProvider.currentUser?.id ?? '');
        Navigator.pop(context);
      });
    }
  }
}
