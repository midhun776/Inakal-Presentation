import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inakal/common/widgets/custom_button.dart';
import 'package:inakal/constants/app_constants.dart';
import 'package:inakal/features/home/service/home_service.dart';
import 'package:inakal/features/profile/model/other_profile_model.dart';
import 'package:inakal/features/profile/service/other_profile_service.dart';
import 'package:inakal/features/profile/widgets/other_profile_detail_card.dart';
import 'package:inakal/features/requests/widgets/accept_button.dart';
import 'package:inakal/features/requests/widgets/decline_button.dart';
import 'package:inakal/features/requests/widgets/message_button.dart';

class OtherProfileScreen extends StatefulWidget {
  final String id;
  const OtherProfileScreen({super.key, required this.id});

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  OtherProfileModel? otherUserModel;
  User userData = User();
  bool isLoading = true;
  String? requestStatus = "Pending";

  final List<String> imagePaths = [
    "assets/vectors/suriya.jpeg",
    "assets/vectors/suriya2.webp",
    "assets/vectors/suriya3.jpg",
  ];

  final List<Gallery>? galleryImages = [];
  final ScrollController _scrollController = ScrollController();
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    getRequestStatus();
  }

  Future<void> getUserData() async {
    await OtherProfileService()
        .getOtherProfile(widget.id, context)
        .then((value) {
      setState(() {
        otherUserModel = value;
        userData = otherUserModel?.user ?? User();
        galleryImages?.add(Gallery(image: userData.image ?? ""));
        galleryImages?.addAll(otherUserModel?.gallery ?? []);
        print("first: ${galleryImages?.length}");
        if (galleryImages!.length == 0) {
          galleryImages?.add(Gallery(
              image:
                  "https://i.pinimg.com/736x/dc/9c/61/dc9c614e3007080a5aff36aebb949474.jpg"));
        }
        print(galleryImages?.length);
        isLoading = false;
      });
    });
  }

  Future<void> getRequestStatus() async {
    await OtherProfileService().getRequestStatus(widget.id).then((value) {
      //(otherUserModel?.user?.id ?? "").then((value){
      setState(() {
        requestStatus = value;
        print("Request status: $requestStatus");
      });
    });
  }

  Future<void> sendInterestToUser() async {
    await HomeService().sentInterestToUser(widget.id, context).then((value) {
      print("Hi: ${value?.type}");
      if (value?.type == "success") {
        getRequestStatus();
      }
    });
  }

  void _nextImage() {
    setState(() {
      currentIndex = currentIndex + 1;
    });
    updateIndex(currentIndex);
    _scrollToCurrentIndex();
  }

  void _previousImage() {
    setState(() {
      currentIndex = currentIndex - 1;
    });
    updateIndex(currentIndex);
    _scrollToCurrentIndex();
  }

  void _scrollToCurrentIndex() {
    double itemWidth = 16; // dot size + margin (e.g., 8 + 4*2)
    double offset = (itemWidth * currentIndex) - 100; // center-ish offset
    _scrollController.animateTo(
      offset < 0 ? 0 : offset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void updateIndex(int index) {
    _scrollToCurrentIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(userData.firstName != null
              ? "${userData.firstName} ${userData.lastName}"
              : ""),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  color: AppColors.white,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 150,
                          decoration: const BoxDecoration(
                            gradient: AppColors.lightPinkWhiteGradient,
                          ),
                        ),
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  child: Image(
                                    image: CachedNetworkImageProvider(
                                        galleryImages?[currentIndex].image ??
                                            "https://i.pinimg.com/736x/dc/9c/61/dc9c614e3007080a5aff36aebb949474.jpg"),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image(
                                        image: const NetworkImage(
                                          "https://i.pinimg.com/736x/dc/9c/61/dc9c614e3007080a5aff36aebb949474.jpg",
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                galleryImages!.length > 1
                                    ? Positioned(
                                        bottom: 10,
                                        child: SizedBox(
                                          // width: MediaQuery.of(context).size.width,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            controller: _scrollController,
                                            child: SizedBox(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: List.generate(
                                                  galleryImages?.length ?? 0,
                                                  (index) => Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4.0),
                                                    width: currentIndex == index
                                                        ? 10.0
                                                        : 8.0,
                                                    height:
                                                        currentIndex == index
                                                            ? 10.0
                                                            : 8.0,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          currentIndex == index
                                                              ? Colors.pink
                                                              : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                currentIndex != 0
                                    ? Positioned(
                                        left: 10,
                                        child: IconButton(
                                          icon: const Icon(Icons.arrow_back_ios,
                                              color: Colors.white),
                                          onPressed: _previousImage,
                                        ),
                                      )
                                    : Container(),
                                currentIndex != (galleryImages?.length ?? 0) - 1
                                    ? Positioned(
                                        right: 10,
                                        child: IconButton(
                                          icon: const Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white),
                                          onPressed: _nextImage,
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                          userData.firstName != null
                                              ? "${userData.firstName} ${userData.lastName}"
                                              : "",
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text("${userData.occupation}",
                                          style: const TextStyle(fontSize: 16)),
                                      const SizedBox(width: 5),
                                      const Text("|",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.grey)),
                                      const SizedBox(width: 5),
                                      Text(
                                          "${userData.district}, ${userData.state}",
                                          style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text("INK${userData.id}",
                                          style: TextStyle(fontSize: 20)),
                                      SizedBox(width: 5),
                                      Text("|",
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: AppColors.grey)),
                                      SizedBox(width: 5),
                                      Text("Last seen today at 11:11am",
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(userData.gender ?? "",
                                          style: TextStyle(fontSize: 16)),
                                      const SizedBox(width: 5),
                                      const Text("|",
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: AppColors.grey)),
                                      const SizedBox(width: 5),
                                      Text(
                                          "${userData.height}cm, ${userData.weight} Kg",
                                          style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Text(userData.aboutMe ?? "",
                                      style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Personal Details",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        OtherProfileDetailCard(
                                            title: "Height",
                                            value: userData.height ?? ""),
                                        OtherProfileDetailCard(
                                            title: "Weight",
                                            value: userData.weight ?? ""),
                                        OtherProfileDetailCard(
                                            title: "Religion",
                                            value: userData.religion ?? ""),
                                        OtherProfileDetailCard(
                                            title: "Caste",
                                            value: userData.caste ?? ""),
                                        OtherProfileDetailCard(
                                            title: "Mother Tongue",
                                            value: userData.motherTongue ?? ""),
                                        OtherProfileDetailCard(
                                            title: "Marital Status",
                                            value:
                                                userData.maritalStatus ?? ""),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  const Text("Educational Details",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        OtherProfileDetailCard(
                                            title: "Qualification",
                                            value: userData.highestEducation ??
                                                ""),
                                        OtherProfileDetailCard(
                                            title: "Job",
                                            value: userData.occupation ?? ""),
                                        OtherProfileDetailCard(
                                            title: "Income",
                                            value: userData.annualIncome ?? ""),
                                        OtherProfileDetailCard(
                                            title: "Working Location",
                                            value: userData.workLocation ?? ""),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  const Text("Additional Details",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        OtherProfileDetailCard(
                                            title: "Smoking Habit",
                                            value:
                                                userData.smokingHabits ?? ""),
                                        OtherProfileDetailCard(
                                            title: "Drinking Habit",
                                            value:
                                                userData.drinkingHabits ?? ""),
                                        OtherProfileDetailCard(
                                            title: "Profile created by",
                                            value: userData.profileCreatedBy ??
                                                ""),
                                        OtherProfileDetailCard(
                                            title: "Hobbies",
                                            value: userData.hobbies ?? ""),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Builder(
                                builder: (_) {
                                  switch (requestStatus) {
                                    case "waiting":
                                      return const CustomButton(
                                          text: "Waiting for response");
                                    case "acceptOrDecline":
                                      return const Row(
                                        children: [
                                          Expanded(
                                              child: DeclineButton(
                                                  text: "Decline")),
                                          SizedBox(width: 10),
                                          Expanded(
                                              child:
                                                  AcceptButton(text: "Accept")),
                                        ],
                                      );
                                    case "message":
                                      return const CustomButton(
                                          text:
                                              "Message"); // Replace with your message-related widget
                                    case "rejected":
                                      return const CustomButton(
                                          text: "User not interested");
                                    default:
                                      return CustomButton(
                                          text: "Send Interest",
                                          onPressed: sendInterestToUser); // fallback if status is null or unknown
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            )
                          ]),
                    ],
                  ),
                ),
              ));
  }
}
