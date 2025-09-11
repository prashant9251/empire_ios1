import 'dart:async';

import 'package:empire_ios/Models/TaskModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/TaskAdd/TaskAdd.dart';
import 'package:empire_ios/screen/TaskList/TaskList.dart';
import 'package:empire_ios/screen/TaskList/TaskListCubit.dart';
import 'package:empire_ios/screen/TaskManager/TaskManagerCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<TaskTypeModel> taskTypeList = [];
var userList = [];

class TaskManager extends StatefulWidget {
  const TaskManager({Key? key}) : super(key: key);

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  late TaskManagerCubit cubit;
  var loading = true;

  initState() {
    super.initState();
    cubit = BlocProvider.of<TaskManagerCubit>(context);
    fetchTaskTypes().then((value) async {
      await fetchUsers();
    });
  }

  Future<void> fetchTaskTypes() async {
    await fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("CrmTaskManage")
        .doc("Data")
        .collection("TaskType")
        .get()
        .then((value) async {
      var snp = value.docs;
      taskTypeList = [];
      await Future.wait(snp.map((e) async {
        dynamic d = e.data();
        TaskTypeModel taskTypeModel = TaskTypeModel.fromJson(d);
        taskTypeList.add(taskTypeModel);
      }).toList());
      taskTypeList.sort((a, b) => a.name!.compareTo(b.name!));
    });
  }

  Future<void> fetchUsers() async {
    await fireBCollection.collection("supuser").doc(GLB_CURRENT_USER["CLIENTNO"]).collection("user").get().then((value) async {
      var snp = value.docs;
      userList = [];
      await Future.wait(snp.map((e) async {
        dynamic d = e.data();
        userList.add(d);
      }).toList());
      userList.sort((a, b) => a["userID"].compareTo(b["userID"]));
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userList.clear();
    taskTypeList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: jsmColor,
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
          title: const Text(
            "Task Manager",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1.2,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(130.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.white],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.purple.shade200),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: cubit.selectedUser,
                              items: [
                                DropdownMenuItem(
                                  value: 'All Users',
                                  child: Row(
                                    children: [
                                      Icon(Icons.account_circle, color: Colors.purple, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'ALL USERS',
                                        style: TextStyle(
                                          color: Colors.purple[900],
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...userList.map<DropdownMenuItem<String>>((user) {
                                  return DropdownMenuItem(
                                    value: user["userID"],
                                    child: Row(
                                      children: [
                                        Icon(Icons.account_circle, color: Colors.purple, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          Myf.getUserNameString(user["userID"]).toString().toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.purple[900],
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  cubit.selectedUser = value!;
                                });
                                cubit.loadData();
                              },
                              style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                              dropdownColor: Colors.white,
                              icon: Icon(Icons.arrow_drop_down, color: Colors.purple),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.white],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: cubit.selectedTaskType,
                              items: [
                                DropdownMenuItem(
                                  value: 'All Task Types',
                                  child: Row(
                                    children: [
                                      Icon(Icons.label_important, color: Colors.blueAccent, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'ALL TASK TYPES',
                                        style: TextStyle(
                                          color: Colors.blue[900],
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...taskTypeList.map<DropdownMenuItem<String>>((taskType) {
                                  return DropdownMenuItem(
                                    value: taskType.id,
                                    child: Row(
                                      children: [
                                        Icon(Icons.label_important, color: Colors.blueAccent, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          taskType.name?.toUpperCase() ?? '',
                                          style: TextStyle(
                                            color: Colors.blue[900],
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  cubit.selectedTaskType = value!;
                                });
                                cubit.loadData();
                              },
                              style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                              dropdownColor: Colors.white,
                              icon: Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    // color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const TabBar(
                    labelColor: Colors.white,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    tabs: [
                      Tab(text: 'Todays'),
                      Tab(text: 'Pending'),
                      Tab(text: 'Running'),
                      Tab(text: 'Completed'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: Column(
                  children: [
                    Expanded(
                      child: BlocBuilder<TaskManagerCubit, TaskManagerState>(
                        builder: (context, state) {
                          if (state is TaskManagerLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is TaskManagerLoadWidget) {
                            return state.widget;
                          } else if (state is TaskManagerError) {
                            return Center(child: Text(state.message));
                          }
                          return Container();
                        },
                      ),
                    ),
                  ],
                ),
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: jsmColor,
          onPressed: () async {
            TaskModel newTask = TaskModel(id: DateTime.now().toString());
            await Myf.Navi(context, TaskAdd(taskModel: newTask));
            setState(() {});
          },
          child: const Icon(Icons.add, size: 28, color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
