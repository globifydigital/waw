class CardAchievedModel {
  bool? success;
  String? message;
  List<CardAchievedList>? data;

  CardAchievedModel({this.success, this.message, this.data});

  CardAchievedModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CardAchievedList>[];
      json['data'].forEach((v) {
        data!.add(new CardAchievedList.fromJson(v));
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

class CardAchievedList {
  int? id;
  int? userId;
  int? seasonId;
  String? coupenNo;
  int? userPoints;
  String? totalWatchTime;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  User? user;

  CardAchievedList(
      {this.id,
        this.userId,
        this.seasonId,
        this.coupenNo,
        this.userPoints,
        this.totalWatchTime,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.user});

  CardAchievedList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    seasonId = json['season_id'];
    coupenNo = json['coupen_no'];
    userPoints = json['user_points'];
    totalWatchTime = json['total_watch_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['season_id'] = this.seasonId;
    data['coupen_no'] = this.coupenNo;
    data['user_points'] = this.userPoints;
    data['total_watch_time'] = this.totalWatchTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
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

  User(
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

  User.fromJson(Map<String, dynamic> json) {
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
