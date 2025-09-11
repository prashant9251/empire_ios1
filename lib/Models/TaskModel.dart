import 'package:empire_ios/screen/EMPIRE/Myf.dart';

class TaskModel {
  String? id;
  String? title;
  String? description;
  String? assignedTo;
  String? taskType;
  String? status;
  String? createdAt;
  String? createdBY;
  String? mTime;
  String? taskDate;
  List<TaskResponseModel>? responses = [];
  TaskModel({
    this.id,
    this.title,
    this.description,
    this.assignedTo,
    this.taskType,
    this.status,
    this.createdAt,
    this.createdBY,
    this.mTime,
    this.responses,
    this.taskDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    List<TaskResponseModel> responses = [];
    if (json['responses'] != null) {
      json['responses'].forEach((v) {
        responses.add(TaskResponseModel.fromJson(v));
      });
    }
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['descp'],
      assignedTo: json['asnTo'],
      taskType: json['tskTyp'],
      status: json['sts'] ?? "P",
      createdAt: json['cAt'] ?? DateTime.now().toString(),
      createdBY: json['cBY'] ?? "Unknown",
      mTime: json['mT'] ?? DateTime.now().toString(),
      responses: responses,
      taskDate: Myf.dateFormateYYYYMMDD("${json['tskDt']}", formate: "yyyy-MM-dd"),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'descp': description,
      'asnTo': assignedTo,
      'tskTyp': taskType,
      'sts': status ?? "P",
      'cAt': createdAt ?? DateTime.now().toString(),
      'cBY': createdBY ?? "Unknown",
      'mT': mTime ?? DateTime.now().toString(),
      'responses': (responses ?? []).map((v) => v.toJson()).toList(),
      'tskDt': (taskDate != null && taskDate!.isNotEmpty)
          ? Myf.dateFormateYYYYMMDD(taskDate!, formate: "yyyy-MM-dd")
          : Myf.dateFormateYYYYMMDD(DateTime.now(), formate: "yyyy-MM-dd"),
    };
  }
}

class TaskResponseModel {
  String? msg;
  String? cBy;
  String? mTime;
  String? type;

  TaskResponseModel({
    this.msg,
    this.cBy,
    this.mTime,
    this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'cBy': cBy,
      'mT': mTime,
      'type': type,
    };
  }

  factory TaskResponseModel.fromJson(Map<String, dynamic> json) {
    return TaskResponseModel(
      msg: json['msg'],
      cBy: json['cBy'],
      mTime: json['mT'],
      type: json['type'],
    );
  }
}

class TaskTypeModel {
  String? id;
  String? name;

  TaskTypeModel({
    this.id,
    this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory TaskTypeModel.fromJson(Map<String, dynamic> json) {
    return TaskTypeModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

var TaskStatusMap = {
  "P": "Pending",
  "R": "Running",
  "C": "Completed",
  "A": "Archived",
};
