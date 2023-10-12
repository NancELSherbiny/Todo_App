import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/home/tasklist/task_widget_item.dart';
import 'package:todo/mytheme.dart';
import 'package:todo/provider/app_config_provider.dart';

class TaskListTap extends StatefulWidget {
  @override
  State<TaskListTap> createState() => _TaskListTapState();
}

class _TaskListTapState extends State<TaskListTap> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Column(
      children: [
        CalendarTimeline(
          initialDate: provider.selectedDate,
          firstDate: DateTime.now().subtract(Duration(days: 365)),
          lastDate: DateTime.now().add(Duration(days: 365)),
          onDateSelected: (date) {
            provider.changeSelectedDate(date);
          },
          leftMargin: 20,
          monthColor: MyTheme.blackColor,
          dayColor: Theme.of(context).primaryColor,
          activeDayColor: MyTheme.whiteColor,
          activeBackgroundDayColor: Theme.of(context).primaryColor,
          dotsColor: MyTheme.whiteColor,
          selectableDayPredicate: (date) => true,
          locale: 'en_ISO',
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (__, index) {
              return TaskWidgetItem(
                task: provider.tasksList[index],
              );
            },
            itemCount: provider.tasksList.length,
          ),
        )
      ],
    );
  }
}
