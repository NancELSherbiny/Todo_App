import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/mytheme.dart';

import '../../Dialog_utils/dialog_utils.dart';
import '../../FireBaseUtils.dart';
import '../../model/task.dart';
import '../../provider/app_config_provider.dart';
import '../../provider/auth_provider.dart';

class EditTaskScreen extends StatefulWidget {
  static const String routeName = 'edit_task_screen';

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  DateTime selectedDate = DateTime.now();

  var formKey = GlobalKey<FormState>();

  String title = '';

  String description = '';

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  Task? task;

  late AppConfigProvider provider;

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      task = ModalRoute.of(context)!.settings.arguments as Task;
      selectedDate = task!.dateTime!;
      titleController.text = task!.title ?? '';
      descriptionController.text = task!.description ?? '';
    }
    provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('To Do List'),
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                color: MyTheme.primaryLight,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: MyTheme.whiteColor,
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Text('Edit Task',
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
                                initialValue: title,
                                onChanged: (text) {
                                  title = text;
                                },
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Please enter task title';
                                  }
                                  return null;
                                },
                                maxLines: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue: description,
                                onChanged: (text) {
                                  description = text;
                                },
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Please enter task description';
                                  }
                                  return null;
                                },
                                maxLines: 4,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                'select date',
                                style: provider.isDarkMode()
                                    ? TextStyle(
                                        color: MyTheme.greyColor, fontSize: 22)
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
                                      ? TextStyle(
                                          color: MyTheme.greyColor,
                                          fontSize: 22)
                                      : Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  editTask();
                                },
                                child: Text(
                                  'Save changes',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ))
                          ],
                        ))
                  ],
                ),
              )
            ],
          )
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

  void editTask() {
    if (formKey.currentState?.validate() == true) {
      task!.title = titleController.text;
      task!.description = descriptionController.text;
      task!.dateTime = selectedDate;
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      DialogUtils.showLoading(context, 'Waiting...');
      FireBaseUtils.updateTask(task!, authProvider.currentUser?.id ?? "")
          .then((value) {
        DialogUtils.hideLoading(context);
      }).timeout(Duration(milliseconds: 500), onTimeout: () {
        Fluttertoast.showToast(
            msg: "Task edited successfully",
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
