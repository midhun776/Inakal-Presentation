class UploadImageModel {
  String? url;
  String? status;
  String? message;

  UploadImageModel({this.url, this.status, this.message});

  UploadImageModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'status': status,
      'message': message,
    };
  }

  get imageUrl => url;
}
