class AllVideos {
  bool? success;
  String? message;
  List<AllVideosListModel>? data;

  AllVideos({this.success, this.message, this.data});

  AllVideos.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AllVideosListModel>[];
      json['data'].forEach((v) {
        data!.add(new AllVideosListModel.fromJson(v));
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

class AllVideosListModel {
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

  AllVideosListModel(
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

  AllVideosListModel.fromJson(Map<String, dynamic> json) {
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