class SuggestedMatchesModel {
  List<SuggestedMatches>? suggestedMatches;
  String? message;
  String? type;

  SuggestedMatchesModel({this.suggestedMatches, this.message, this.type});

  SuggestedMatchesModel.fromJson(Map<String, dynamic> json) {
    if (json['suggestedMatches'] != null) {
      suggestedMatches = <SuggestedMatches>[];
      json['suggestedMatches'].forEach((v) {
        suggestedMatches!.add(new SuggestedMatches.fromJson(v));
      });
    }
    message = json['message'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.suggestedMatches != null) {
      data['suggestedMatches'] =
          this.suggestedMatches!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['type'] = this.type;
    return data;
  }
}

class SuggestedMatches {
  String? userId;
  String? name;
  String? image;
  String? location;
  String? dob;

  SuggestedMatches(
      {this.userId, this.name, this.image, this.location, this.dob});

  SuggestedMatches.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    image = json['image'];
    location = json['location'];
    dob = json['dob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['location'] = this.location;
    data['dob'] = this.dob;
    return data;
  }
}
