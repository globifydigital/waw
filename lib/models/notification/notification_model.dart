class NotificationModel {
  bool? success;
  String? message;
  List<NotificationList>? data;

  NotificationModel({this.success, this.message, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationList>[];
      json['data'].forEach((v) {
        data!.add(new NotificationList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationList {
  int? id;
  int? videoAnnouncementId;
  String? title;
  String? description;
  String? date;
  String? time;
  String? flag;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  NotificationList(
      {this.id,
        this.videoAnnouncementId,
        this.title,
        this.description,
        this.date,
        this.time,
        this.flag,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  NotificationList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoAnnouncementId = json['video_announcement_id'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    time = json['time'];
    flag = json['flag'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['video_announcement_id'] = this.videoAnnouncementId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['date'] = this.date;
    data['time'] = this.time;
    data['flag'] = this.flag;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
