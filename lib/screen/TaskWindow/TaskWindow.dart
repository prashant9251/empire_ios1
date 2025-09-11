import 'package:bubble/bubble.dart';
import 'package:empire_ios/Models/TaskModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/TaskManager/TaskManager.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';

class TaskWindow extends StatefulWidget {
  TaskWindow({Key? key, required this.taskModel}) : super(key: key);
  TaskModel taskModel;
  @override
  State<TaskWindow> createState() => _TaskWindowState();
}

class _TaskWindowState extends State<TaskWindow> {
  var formKey = GlobalKey<FormState>();

  var ctrlResponse = TextEditingController();
  var loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() {
    fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("CrmTaskManage")
        .doc("Data")
        .collection("crmTask")
        .doc(widget.taskModel.id)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          widget.taskModel = TaskModel.fromJson(value.data()!);
          loading = false;
        });
      }
    }).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Task Window"),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.blue.shade100, width: 1.5),
                      ),
                      elevation: 8,
                      shadowColor: Colors.blueAccent.withOpacity(0.15),
                      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.blue.shade50, Colors.blue.shade100],
                                ),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: widget.taskModel.taskType,
                                  items: [
                                    for (var taskType in taskTypeList)
                                      DropdownMenuItem(
                                        value: taskType.id,
                                        child: Row(
                                          children: [
                                            Icon(Icons.label_important, color: Colors.blueAccent, size: 20),
                                            SizedBox(width: 8),
                                            Text(
                                              "${taskType.name}",
                                              style: TextStyle(
                                                color: Colors.blue[900],
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                  onChanged: (String? newValue) async {
                                    var yesNO =
                                        await Myf.yesNoShowDialod(context, title: "Alert", msg: "Are you sure you want to change the task type?");
                                    if (yesNO == true) {
                                      var oldTaskName = widget.taskModel.taskType;
                                      widget.taskModel.taskType = newValue;
                                      TaskResponseModel response = TaskResponseModel(
                                        msg: "Task type changed From ${oldTaskName} to ${newValue}",
                                        cBy: loginUserModel.loginUser,
                                        mTime: DateTime.now().toString(),
                                        type: "ttc",
                                      );
                                      (widget.taskModel.responses ?? []).add(response);
                                      save();
                                    }
                                  },
                                  style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                                  dropdownColor: Colors.white,
                                  icon: Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.purple.shade50, Colors.purple.shade100],
                                ),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.purple.shade200),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: widget.taskModel.assignedTo,
                                  items: [
                                    ...userList
                                        .map((user) => DropdownMenuItem<String>(
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
                                            ))
                                        .toList()
                                  ],
                                  onChanged: (String? newValue) async {
                                    var yesNo = await Myf.yesNoShowDialod(context,
                                        title: "Change Assignee", msg: "Are you sure you want to change the assignee?");
                                    if (yesNo == true) {
                                      var oldAssignee2 = widget.taskModel.assignedTo;
                                      widget.taskModel.assignedTo = newValue;
                                      TaskResponseModel model = TaskResponseModel(
                                        msg: "Task assignee changed from ${(oldAssignee2)} to ${(newValue)}",
                                        cBy: loginUserModel.loginUser,
                                        mTime: DateTime.now().toString(),
                                        type: "as_c",
                                      );
                                      (widget.taskModel.responses ??= []).add(model);
                                      save();
                                    }
                                  },
                                  style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                                  dropdownColor: Colors.white,
                                  icon: Icon(Icons.arrow_drop_down, color: Colors.purple),
                                ),
                              ),
                            ),
                            SizedBox(height: 14),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: Colors.blue.shade100),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Icon(Icons.info_outline, color: jsmColor, size: 30),
                                ),
                                SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    "Task Status",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: jsmColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.green.shade50, Colors.green.shade100],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.green.shade200),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: widget.taskModel.status ?? 'P',
                                      items: [
                                        {'label': 'Pending', 'value': 'P'},
                                        {'label': 'Running', 'value': 'R'},
                                        {'label': 'Completed', 'value': 'C'},
                                      ]
                                          .map((status) => DropdownMenuItem(
                                                value: status['value'],
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      status['value'] == 'P'
                                                          ? Icons.hourglass_empty
                                                          : status['value'] == 'R'
                                                              ? Icons.play_arrow
                                                              : Icons.check_circle,
                                                      color: status['value'] == 'P'
                                                          ? Colors.orange
                                                          : status['value'] == 'R'
                                                              ? Colors.blue
                                                              : Colors.green,
                                                      size: 22,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      status['label']!,
                                                      style: TextStyle(
                                                        color: status['value'] == 'P'
                                                            ? Colors.orange
                                                            : status['value'] == 'R'
                                                                ? Colors.blue
                                                                : Colors.green,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (String? newValue) async {
                                        var yesNo = await Myf.yesNoShowDialod(context,
                                            title: "Change Status", msg: "Are you sure you want to change the status?");
                                        if (yesNo == true) {
                                          var oldStatus = TaskStatusMap[widget.taskModel.status];
                                          widget.taskModel.status = newValue;
                                          var newStatus = TaskStatusMap[widget.taskModel.status];
                                          TaskResponseModel model = TaskResponseModel(
                                            msg: "Task status changed from ${(oldStatus)} to ${(newStatus)}",
                                            cBy: loginUserModel.loginUser,
                                            mTime: DateTime.now().toString(),
                                            type: "s_c",
                                          );
                                          (widget.taskModel.responses ??= []).add(model);
                                          save();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                                SizedBox(width: 6),
                                Text(
                                  "Created: ${Myf.dateFormateYYYYMMDD(widget.taskModel.createdAt, formate: "dd-MMM-yy hh:mm:a")}",
                                  style: TextStyle(fontSize: 15, color: Colors.grey[700], fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.task, color: Colors.blueGrey[700], size: 24),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Task: ${widget.taskModel.description ?? ""}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blueGrey[900],
                                        letterSpacing: 0.2,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(thickness: 1),
                    Expanded(
                      child: Builder(builder: (context) {
                        widget.taskModel.responses!.sort((a, b) => b.mTime!.compareTo(a.mTime!));
                        return ListView.builder(
                          reverse: true,
                          itemBuilder: (context, index) {
                            final response = widget.taskModel.responses![index];
                            return taskBubbleCard(response);
                          },
                          itemCount: (widget.taskModel.responses ?? []).length,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: ctrlResponse,
                              decoration: InputDecoration(
                                hintText: "Type your response...",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Please enter a response";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                TaskResponseModel response = TaskResponseModel(
                                  msg: ctrlResponse.text.toUpperCase().trim(),
                                  cBy: loginUserModel.loginUser,
                                  mTime: DateTime.now().toString(),
                                  type: "cmt",
                                );
                                widget.taskModel.responses = (widget.taskModel.responses ?? [])..add(response);
                                save();
                              }
                            },
                            child: Icon(Icons.send, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              shape: CircleBorder(),
                              backgroundColor: jsmColor, // <-- Button color
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  save() {
    widget.taskModel.mTime = DateTime.now().toString();
    fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("CrmTaskManage")
        .doc("Data")
        .collection("crmTask")
        .doc(widget.taskModel.id)
        .update(widget.taskModel.toJson())
        .then((value) {
      ctrlResponse.clear();
      getData();
    }).catchError((error) {});
  }
}

Widget taskBubbleCard(TaskResponseModel response) {
  return Align(
    alignment: response.cBy == loginUserModel.loginUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Bubble(
      margin: BubbleEdges.only(
          top: 10, left: response.cBy == loginUserModel.loginUser ? 40 : 0, right: response.cBy == loginUserModel.loginUser ? 0 : 40),
      alignment: response.cBy == loginUserModel.loginUser ? Alignment.topRight : Alignment.topLeft,
      nip: response.cBy == loginUserModel.loginUser ? BubbleNip.rightTop : BubbleNip.leftTop,
      color: response.type == "cmt"
          ? (response.cBy == loginUserModel.loginUser ? Colors.blue.shade100 : Colors.grey.shade200)
          : (response.type == "s_c"
              ? Colors.green.shade100
              : response.type == "as_c"
                  ? Colors.purple.shade100
                  : Colors.orange.shade100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (response.type != "cmt")
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  Icon(
                    response.type == "s_c"
                        ? Icons.check_circle
                        : response.type == "as_c"
                            ? Icons.person
                            : Icons.label_important,
                    color: response.type == "s_c"
                        ? Colors.green
                        : response.type == "as_c"
                            ? Colors.purple
                            : Colors.orange,
                    size: 18,
                  ),
                  SizedBox(width: 6),
                  Text(
                    response.type == "s_c"
                        ? "Status Changed"
                        : response.type == "as_c"
                            ? "Assignee Changed"
                            : "Task Type Changed",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          Text(
            "${response.msg}",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "By ${Myf.getUserNameString("${response.cBy}")}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                "${Myf.dateFormateYYYYMMDD(response.mTime, formate: "dd-MMM-yy hh:mm a")}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
