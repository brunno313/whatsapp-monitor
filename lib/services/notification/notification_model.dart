class NotificationModel {
  final int? id;
  final String title;
  final String message;
  final String? appIcon;
  final String? largeIcon;
  final DateTime dateTime;

  NotificationModel({
    this.id,
    required this.title,
    required this.message,
    this.appIcon,
    this.largeIcon,
    required this.dateTime,
  });

  // Convert a NotificationModel into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'appIcon': appIcon,
      'largeIcon': largeIcon,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  // Convert a Map into a NotificationModel.
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      message: map['message'] as String,
      appIcon: map['appIcon'] as String?,
      largeIcon: map['largeIcon'] as String?,
      dateTime: DateTime.parse(map['dateTime'] as String),
    );
  }
}
