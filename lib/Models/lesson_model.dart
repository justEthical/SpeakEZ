class LessonModel {
  final String id;
  final String name;
  final String purpose;
  final String cefrLevel;

  LessonModel({
    required this.id,
    required this.name,
    required this.purpose,
    required this.cefrLevel,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'],
      name: json['name'],
      purpose: json['purpose'],
      cefrLevel: json['cefrLevel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'purpose': purpose,
      'cefrLevel': cefrLevel,
    };
  }
}
