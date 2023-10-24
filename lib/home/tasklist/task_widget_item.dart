import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/FireBaseUtils.dart';
import 'package:todo/home/tasklist/edit_task_screen.dart';
import 'package:todo/mytheme.dart';
import 'package:todo/provider/app_config_provider.dart';
import 'package:todo/provider/auth_provider.dart';

import '../../model/task.dart';

class TaskWidgetItem extends StatefulWidget {
  Task task;

  TaskWidgetItem({required this.task});
  @override
  State<TaskWidgetItem> createState() => _TaskWidgetItemState();
}

class _TaskWidgetItemState extends State<TaskWidgetItem> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var provider = Provider.of<AppConfigProvider>(context);
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(EditTaskScreen.routeName, arguments: widget.task);
        print('edit task');
      },
      child: Container(
        margin: EdgeInsets.all(12),
        child: Slidable(
          startActionPane: ActionPane(
            extentRatio: 0.2,
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                onPressed: (context) {
                  FireBaseUtils.deleteTaskFromFirebase(
                          widget.task, authProvider.currentUser?.id ?? "")
                      .timeout(Duration(milliseconds: 500), onTimeout: () {
                    print('task was deleted');
                    provider.getAllTasksFromFireStore(
                        authProvider.currentUser?.id ?? "");
                  });
                },
                backgroundColor: MyTheme.redColor,
                foregroundColor: MyTheme.whiteColor,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            child: Container(
              margin: EdgeInsets.only(top: 12, bottom: 12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: provider.isDarkMode()
                      ? MyTheme.blackDark
                      : MyTheme.whiteColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: widget.task.isDone!
                        ? MyTheme.greenColor
                        : Theme.of(context).primaryColor,
                    height: 80,
                    width: 4,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.task.title ?? '',
                          style: widget.task.isDone!
                              ? TextStyle(
                                  fontSize: 27,
                                  color: MyTheme.greenColor,
                                  fontWeight: FontWeight.bold)
                              : Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.task.title ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: 23),
                        ),
                      ),
                    ],
                  )),
                  InkWell(
                    onTap: () {
                      FireBaseUtils.updateIsDone(
                          widget.task, authProvider.currentUser?.id ?? '');
                      widget.task.isDone = !widget.task.isDone!;
                      setState(() {});
                    },
                    child: widget.task.isDone!
                        ? Text(
                            'done!',
                            style: TextStyle(
                                color: MyTheme.greenColor,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 22, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Icon(
                              Icons.check,
                              color: MyTheme.whiteColor,
                              size: 35,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
