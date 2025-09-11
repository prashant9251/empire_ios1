// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ResponseSuggetionsModel {
  String? solution;
  String? desc;
  String? issueType;
  String? id;
  ResponseSuggetionsModel({
    this.solution,
    this.desc,
    this.issueType,
    this.id,
  });

  ResponseSuggetionsModel copyWith({
    String? solution,
    String? desc,
    String? issueType,
    String? id,
  }) {
    return ResponseSuggetionsModel(
      solution: solution ?? this.solution,
      desc: desc ?? this.desc,
      issueType: issueType ?? this.issueType,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'solution': solution,
      'desc': desc,
      'issueType': issueType,
      'id': id,
    };
  }

  factory ResponseSuggetionsModel.fromMap(Map<String, dynamic> map) {
    return ResponseSuggetionsModel(
      solution: map['solution'] != null ? map['solution'] as String : null,
      desc: map['desc'] != null ? map['desc'] as String : null,
      issueType: map['issueType'] != null ? map['issueType'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseSuggetionsModel.fromJson(String source) => ResponseSuggetionsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ResponseSuggetionsModel(solution: $solution, desc: $desc, issueType: $issueType, id: $id)';
  }

  @override
  bool operator ==(covariant ResponseSuggetionsModel other) {
    if (identical(this, other)) return true;

    return other.solution == solution && other.desc == desc && other.issueType == issueType && other.id == id;
  }

  @override
  int get hashCode {
    return solution.hashCode ^ desc.hashCode ^ issueType.hashCode ^ id.hashCode;
  }
}
