import 'package:empire_ios/Models/TaskModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/TaskWindow/TaskWindow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskListCubit extends Cubit<TaskListState> {
  List<TaskModel> taskList = [];
  bool isDisposed = false;
  String status = "";
  BuildContext context;
  String selectedUser;
  int limit = 20;
  bool isLoadingMore = false;
  bool hasMore = true;
  dynamic lastDocument;
  String selectedTaskType;

  TaskListCubit(this.context, {required this.status, required this.selectedUser, required this.selectedTaskType}) : super(TaskListStateInitial()) {
    getData(initial: true);
  }

  Future<void> getData({bool initial = false}) async {
    if (initial) {
      taskList.clear();
      lastDocument = null;
      hasMore = true;
    }
    if (!hasMore || isLoadingMore) return;
    isLoadingMore = true;

    var collection =
        fireBCollection.collection("supuser").doc(GLB_CURRENT_USER["CLIENTNO"]).collection("CrmTaskManage").doc("Data").collection("crmTask");
    var where = collection.where("sts", isEqualTo: status);
    if (status.isEmpty) {
      DateTime today = DateTime.now();
      String todayStr = Myf.dateFormateYYYYMMDD(today.toString(), formate: "yyyy-MM-dd");
      where = collection.where('tskDt', isEqualTo: todayStr);
    }
    if (selectedUser != "All Users") {
      where = where.where("asnTo", isEqualTo: selectedUser);
    }

    if (selectedTaskType != "All Task Types") {
      where = where.where("tskTyp", isEqualTo: selectedTaskType);
    }

    var query = where.orderBy("mT", descending: true).limit(limit);
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    var value = await query.get();
    if (value.docs.isNotEmpty) {
      lastDocument = value.docs.last;
      var newTasks = value.docs.map((doc) => TaskModel.fromJson(Myf.convertMapKeysToString(doc.data()))).toList();
      taskList.addAll(newTasks);
      if (newTasks.length < limit) hasMore = false;
    } else {
      hasMore = false;
    }
    isLoadingMore = false;
    loadData();
  }

  loadData() {
    Widget widget = getList();
    if (!isDisposed) emit(TaskListStateLoadData(widget));
  }

  Widget getList() {
    if (taskList.isEmpty) {
      return Center(
        child: Text(
          "No Task Found",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (hasMore && !isLoadingMore && scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
          getData();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: taskList.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < taskList.length) {
            TaskModel taskModel = taskList[index];
            return TaskCard(taskModel);
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }

  Widget TaskCard(TaskModel taskModel) {
    return GestureDetector(
      onTap: () async {
        await Myf.Navi(this.context, TaskWindow(taskModel: taskModel));
        await getData(initial: true);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.assignment, color: Colors.blueAccent),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Task:${Myf.getSubstring((taskModel.description ?? "").toString(), length: 30)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text("${taskModel.taskType}"),
                    backgroundColor: Colors.blue.shade50,
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person, size: 18, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    "Assigned: ${Myf.getUserNameString((taskModel.assignedTo ?? ""))}",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  Spacer(),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    "Created: ${Myf.dateFormateYYYYMMDD(taskModel.createdAt, formate: "dd-MMM-yy hh:mm:a")}",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  Spacer(),
                ],
              ),
              if ((taskModel.responses ?? []).length > 0) ...[
                Transform.scale(
                  scale: 0.6,
                  child: (() {
                    (taskModel.responses ?? []).sort((a, b) => a.mTime!.compareTo(b.mTime!));
                    return taskBubbleCard((taskModel.responses ?? []).last);
                  })(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

abstract class TaskListState {}

class TaskListStateInitial extends TaskListState {}

class TaskListStateLoadData extends TaskListState {
  final Widget widget;

  TaskListStateLoadData(this.widget);
}
