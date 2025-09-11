import 'package:empire_ios/Models/TaskModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/TaskList/TaskList.dart';
import 'package:empire_ios/screen/TaskList/TaskListCubit.dart';
import 'package:empire_ios/screen/TaskManager/TaskManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskManagerCubit extends Cubit<TaskManagerState> {
  final BuildContext context;
  var selectedUser = "All Users";

  var selectedTaskType = "All Task Types";
  TaskManagerCubit(this.context) : super(TaskManagerInitial()) {
    getData();
  }

  void getData() async {
    loadData();
  }

  void loadData() async {
    Widget w = getWidget();
    emit(TaskManagerLoadWidget(w));
  }

  Widget getWidget() {
    return TabBarView(
      key: UniqueKey(),
      children: [
        BlocProvider(
            create: (context) => TaskListCubit(context, status: "", selectedUser: selectedUser, selectedTaskType: selectedTaskType),
            child: TaskList()),
        BlocProvider(
            create: (context) => TaskListCubit(context, status: "P", selectedUser: selectedUser, selectedTaskType: selectedTaskType),
            child: TaskList()),
        BlocProvider(
            create: (context) => TaskListCubit(context, status: "R", selectedUser: selectedUser, selectedTaskType: selectedTaskType),
            child: TaskList()),
        BlocProvider(
            create: (context) => TaskListCubit(context, status: "C", selectedUser: selectedUser, selectedTaskType: selectedTaskType),
            child: TaskList()),
      ],
    );
  }
}

abstract class TaskManagerState {}

class TaskManagerInitial extends TaskManagerState {}

class TaskManagerLoading extends TaskManagerState {}

class TaskManagerLoadWidget extends TaskManagerState {
  Widget widget;

  TaskManagerLoadWidget(this.widget);
}

class TaskManagerError extends TaskManagerState {
  final String message;

  TaskManagerError(this.message);
}
