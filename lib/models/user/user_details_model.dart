class UserDetails {
  bool? success;
  String? message;
  Data? data;

  UserDetails({this.success, this.message, this.data});

  UserDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? userRole;
  String? name;
  String? mobNo;
  String? whatsappNo;
  String? email;
  String? address;
  String? location;
  String? image;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.userRole,
        this.name,
        this.mobNo,
        this.whatsappNo,
        this.email,
        this.address,
        this.location,
        this.image,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    userRole = json['user_role'];
    name = json['name'];
    mobNo = json['mob_no'];
    whatsappNo = json['whatsapp_no'];
    email = json['email'];
    address = json['address'];
    location = json['location'];
    image = json['image'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_role'] = this.userRole;
    data['name'] = this.name;
    data['mob_no'] = this.mobNo;
    data['whatsapp_no'] = this.whatsappNo;
    data['email'] = this.email;
    data['address'] = this.address;
    data['location'] = this.location;
    data['image'] = this.image;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
