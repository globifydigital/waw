class AllWatchedVideos {
  bool? success;
  String? message;
  List<AllWatchedVideosList>? data;

  AllWatchedVideos({this.success, this.message, this.data});

  AllWatchedVideos.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AllWatchedVideosList>[];
      json['data'].forEach((v) {
        data!.add(new AllWatchedVideosList.fromJson(v));
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

class AllWatchedVideosList {
  int? id;
  int? userId;
  int? videoId;
  String? videoPoints;
  String? videoStartTime;
  String? date;
  int? flag;
  String? duration;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  Video? video;

  AllWatchedVideosList(
      {this.id,
        this.userId,
        this.videoId,
        this.videoPoints,
        this.videoStartTime,
        this.date,
        this.flag,
        this.duration,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.video});

  AllWatchedVideosList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    videoId = json['video_id'];
    videoPoints = json['video_points'];
    videoStartTime = json['video_start_time'];
    date = json['date'];
    flag = json['flag'];
    duration = json['duration'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['video_id'] = this.videoId;
    data['video_points'] = this.videoPoints;
    data['video_start_time'] = this.videoStartTime;
    data['date'] = this.date;
    data['flag'] = this.flag;
    data['duration'] = this.duration;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.video != null) {
      data['video'] = this.video!.toJson();
    }
    return data;
  }
}

class Video {
  int? id;
  int? agencyId;
  String? title;
  String? video;
  String? date;
  String? time;
  String? videoTimeDuration;
  String? videoLink;
  int? totalViews;
  int? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  Video(
      {this.id,
        this.agencyId,
        this.title,
        this.video,
        this.date,
        this.time,
        this.videoTimeDuration,
        this.videoLink,
        this.totalViews,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    agencyId = json['agency_id'];
    title = json['title'];
    video = json['video'];
    date = json['date'];
    time = json['time'];
    videoTimeDuration = json['video_time_duration'];
    videoLink = json['video_link'];
    totalViews = json['total_views'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['agency_id'] = this.agencyId;
    data['title'] = this.title;
    data['video'] = this.video;
    data['date'] = this.date;
    data['time'] = this.time;
    data['video_time_duration'] = this.videoTimeDuration;
    data['video_link'] = this.videoLink;
    data['total_views'] = this.totalViews;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
