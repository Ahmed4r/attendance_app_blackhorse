// {
//   'id':  1
// }

class StdModel {
  final String? id;
  final String name;
  final String age;
  final int rollNumber;
  final String? attendance;

  StdModel(this.id, this.name, this.age, this.rollNumber, this.attendance);

  factory StdModel.fromJson(String? id, Map<String, dynamic> json) {
    return StdModel(
      id,
      json['name'] as String,
      json['age'] as String,
      json['rollN'] as int,
      json['atd'] as String?,
    );
  }

  Map<String, dynamic> tojson() {
    return {'name': name, 'age': age, 'rollN': rollNumber, 'atd': attendance};
  }
}
