class SeasonListModel {
  bool? success;
  String? message;
  List<SeasonList>? data;

  SeasonListModel({this.success, this.message, this.data});

  SeasonListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SeasonList>[];
      json['data'].forEach((v) {
        // Only add SeasonList if the status is 0
        SeasonList seasonList = new SeasonList.fromJson(v);
        if (seasonList.status == 0) {
          data!.add(seasonList);
        }
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

class SeasonList {
  int? id;
  String? name;
  int? seasonTargetPoints;
  int? userTargetPoints;
  String? startDate;
  String? endDate;
  int? cardAchievedCount;
  int? userTotalPoints;
  String? videoLink;
  int? winner1UserId;
  int? winner2UserId;
  int? winner3UserId;
  int? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  Winner1? winner1;
  Winner1? winner2;
  Winner1? winner3;
  bool isExpanded = false;

  SeasonList(
      {this.id,
        this.name,
        this.seasonTargetPoints,
        this.userTargetPoints,
        this.startDate,
        this.endDate,
        this.cardAchievedCount,
        this.userTotalPoints,
        this.videoLink,
        this.winner1UserId,
        this.winner2UserId,
        this.winner3UserId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.winner1,
        this.winner2,
        this.winner3});

  SeasonList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    seasonTargetPoints = json['season_target_points'];
    userTargetPoints = json['user_target_points'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    cardAchievedCount = json['card_achieved_count'];
    userTotalPoints = json['user_total_points'];
    videoLink = json['video_link'];
    winner1UserId = json['winner1_user_id'];
    winner2UserId = json['winner2_user_id'];
    winner3UserId = json['winner3_user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    winner1 =
    json['winner1'] != null ? new Winner1.fromJson(json['winner1']) : null;
    winner2 =
    json['winner2'] != null ? new Winner1.fromJson(json['winner2']) : null;
    winner3 =
    json['winner3'] != null ? new Winner1.fromJson(json['winner3']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['season_target_points'] = this.seasonTargetPoints;
    data['user_target_points'] = this.userTargetPoints;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['card_achieved_count'] = this.cardAchievedCount;
    data['user_total_points'] = this.userTotalPoints;
    data['video_link'] = this.videoLink;
    data['winner1_user_id'] = this.winner1UserId;
    data['winner2_user_id'] = this.winner2UserId;
    data['winner3_user_id'] = this.winner3UserId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.winner1 != null) {
      data['winner1'] = this.winner1!.toJson();
    }
    if (this.winner2 != null) {
      data['winner2'] = this.winner2!.toJson();
    }
    if (this.winner3 != null) {
      data['winner3'] = this.winner3!.toJson();
    }
    return data;
  }
}

class Winner1 {
  int? id;
  String? userRole;
  String? name;
  String? mobNo;
  String? whatsappNo;
  String? email;
  Null? showPassword;
  String? address;
  int? location;
  String? image;
  int? userPoints;
  String? totalWatchTime;
  String? coupenNo;
  Null? otp;
  int? exceedsLimit;
  int? userTargetPoints;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  Winner1(
      {this.id,
        this.userRole,
        this.name,
        this.mobNo,
        this.whatsappNo,
        this.email,
        this.showPassword,
        this.address,
        this.location,
        this.image,
        this.userPoints,
        this.totalWatchTime,
        this.coupenNo,
        this.otp,
        this.exceedsLimit,
        this.userTargetPoints,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Winner1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userRole = json['user_role'];
    name = json['name'];
    mobNo = json['mob_no'];
    whatsappNo = json['whatsapp_no'];
    email = json['email'];
    showPassword = json['show_password'];
    address = json['address'];
    location = json['location'];
    image = json['image'];
    userPoints = json['user_points'];
    totalWatchTime = json['total_watch_time'];
    coupenNo = json['coupen_no'];
    otp = json['otp'];
    exceedsLimit = json['exceeds_limit'];
    userTargetPoints = json['user_target_points'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_role'] = this.userRole;
    data['name'] = this.name;
    data['mob_no'] = this.mobNo;
    data['whatsapp_no'] = this.whatsappNo;
    data['email'] = this.email;
    data['show_password'] = this.showPassword;
    data['address'] = this.address;
    data['location'] = this.location;
    data['image'] = this.image;
    data['user_points'] = this.userPoints;
    data['total_watch_time'] = this.totalWatchTime;
    data['coupen_no'] = this.coupenNo;
    data['otp'] = this.otp;
    data['exceeds_limit'] = this.exceedsLimit;
    data['user_target_points'] = this.userTargetPoints;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
