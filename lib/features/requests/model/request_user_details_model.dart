class RequestUserDetailsModel {
  final String clientID;
  final String image;
  final String firstName;
  final String lastName;
  final String district;
  final String state;
  final String dob;
  final String height;
  final String religion;
  final String caste;
  final String occupation;
  final String lastSeen;
  final String status;
  final String? requestId;

  RequestUserDetailsModel({
    required this.clientID,
    required this.image,
    required this.firstName,
    required this.lastName,
    required this.district,
    required this.state,
    required this.dob,
    required this.height,
    required this.religion,
    required this.caste,
    required this.occupation,
    required this.lastSeen,
    required this.status,
    required this.requestId,
  });

  factory RequestUserDetailsModel.fromJson(
      Map<String, dynamic> json, String status, String? requestId) {
    return RequestUserDetailsModel(
      clientID: json['id'],
      image: json['image'],
      firstName: json['first_name'] ?? "First Name",
      lastName: json['last_name'] ?? "Last Name",
      district: json['district'],
      state: json['state'],
      dob: json['dob'],
      height: json['height'] ?? "150",
      religion: json['religion'] ?? "Hindu",
      caste: json['caste'] ?? "Nair",
      occupation: json['occupation'] ?? "Software Engineer",
      lastSeen: json['last_seen'] ?? "12/12/2023",
      requestId: requestId,
      status: status,
    );
  }
}
