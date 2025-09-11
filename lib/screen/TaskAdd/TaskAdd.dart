import 'dart:async';

import 'package:empire_ios/Models/TaskModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/TaskManager/TaskManager.dart';
import 'package:empire_ios/screen/newRegistration/newRegistrationButton.dart';
import 'package:flutter/material.dart';

class TaskAdd extends StatefulWidget {
  TaskAdd({Key? key, required this.taskModel}) : super(key: key);
  TaskModel taskModel;
  @override
  State<TaskAdd> createState() => _TaskAddState();
}

class _TaskAddState extends State<TaskAdd> {
  var formKey = GlobalKey<FormState>();
  var loading = true;
  @override
  void initState() {
    super.initState();
    fetchTaskType();
  }

  Future<void> fetchTaskType() async {
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
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: const Text(
          "Add New Task",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Task Details",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: jsmColor,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Fetch users once in initState and store in a variable
                          DropdownButtonFormField<String>(
                            value: widget.taskModel.assignedTo,
                            decoration: InputDecoration(
                              labelText: 'Assign To',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              prefixIcon: Icon(Icons.person, color: jsmColor),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a user';
                              }
                              return null;
                            },
                            items: userList
                                .map((user) => DropdownMenuItem<String>(
                                      value: user["userID"],
                                      child: Text(Myf.getUserNameString(user["userID"]).toString().toUpperCase()),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                widget.taskModel.assignedTo = value;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: widget.taskModel.taskType,
                                  decoration: InputDecoration(
                                    labelText: 'Task Type',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    prefixIcon: Icon(Icons.category, color: jsmColor),
                                  ),
                                  items: [
                                    ...taskTypeList.map((taskType) {
                                      return DropdownMenuItem(
                                        value: taskType.name,
                                        child: Text((taskType.name ?? "").toUpperCase()),
                                      );
                                    }).toList(),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a task type';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      widget.taskModel.taskType = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Tooltip(
                                message: 'Add New Task Type',
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(24),
                                    onTap: () {
                                      TaskTypeModel newTaskType = TaskTypeModel(id: DateTime.now().toString());
                                      AskForTaskTypeAdd(newTaskType);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: jsmColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.add_circle_outline, color: jsmColor, size: 28),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(height: 24),
                          // TextField(
                          //   decoration: InputDecoration(
                          //     labelText: 'Task Title',
                          //     hintText: 'Enter task title',
                          //     prefixIcon: Icon(Icons.title, color: jsmColor),
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(12),
                          //     ),
                          //     filled: true,
                          //     fillColor: Colors.grey[100],
                          //   ),
                          // ),
                          const SizedBox(height: 24),

                          TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: Myf.dateFormateYYYYMMDD(widget.taskModel.taskDate, formate: "dd-MM-yyyy"),
                            ),
                            decoration: InputDecoration(
                              labelText: 'Task Date',
                              hintText: 'Select task date',
                              prefixIcon: Icon(Icons.calendar_today, color: jsmColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            onTap: () async {
                              final DateTime? picked = await Myf.selectDate(context);
                              if (picked != null) {
                                setState(() {
                                  widget.taskModel.taskDate = Myf.dateFormateYYYYMMDD(picked.toString(), formate: "yyyy-MM-dd");
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: TextEditingController(text: widget.taskModel.description),
                            onChanged: (value) {
                              widget.taskModel.description = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter task description';
                              }
                              return null;
                            },
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: 'Task Description',
                              hintText: 'Describe the task...',
                              prefixIcon: Icon(Icons.description, color: jsmColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 32),
                          Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: jsmColor,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: Icon(Icons.save, color: Colors.white),
                                label: Text(
                                  "Save Task",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    fireBCollection
                                        .collection("supuser")
                                        .doc(GLB_CURRENT_USER["CLIENTNO"])
                                        .collection("CrmTaskManage")
                                        .doc("Data")
                                        .collection("crmTask")
                                        .doc(widget.taskModel.id)
                                        .set(widget.taskModel.toJson())
                                        .then((value) {
                                      Myf.snakeBar(context, "Task saved successfully");
                                      Navigator.pop(context);
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void AskForTaskTypeAdd(TaskTypeModel newTaskType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: [
              Icon(Icons.add_circle_outline, color: jsmColor),
              SizedBox(width: 8),
              Text(
                "Add New Task Type",
                style: TextStyle(
                  color: jsmColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          content: TextField(
            onChanged: (value) {
              newTaskType.name = value.toUpperCase().trim();
            },
            autofocus: true,
            controller: TextEditingController(text: newTaskType.name),
            decoration: InputDecoration(
              hintText: "Enter task type name",
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.category, color: jsmColor),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
                textStyle: TextStyle(fontWeight: FontWeight.w600),
              ),
              child: Text("Cancel"),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: jsmColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              ),
              icon: Icon(Icons.check, color: Colors.white, size: 20),
              label: Text(
                "Add",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              onPressed: () async {
                newTaskType.id = newTaskType.name;
                fireBCollection
                    .collection("supuser")
                    .doc(GLB_CURRENT_USER["CLIENTNO"])
                    .collection("CrmTaskManage")
                    .doc("Data")
                    .collection("TaskType")
                    .doc(newTaskType.id)
                    .set(newTaskType.toJson())
                    .then((_) {
                  Navigator.pop(context);
                  fetchTaskType();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
