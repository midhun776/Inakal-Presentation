import 'package:flutter/material.dart';
import 'package:inakal/constants/app_constants.dart';
import 'package:inakal/constants/widgets/light_pink_gradient.dart';
import 'package:inakal/features/chat/models/inbox_model.dart';
import 'package:inakal/features/chat/service/inbox_service.dart';
import 'package:inakal/features/chat/widgets/inbox_card.dart';
import 'package:inakal/data_class/user.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  List<String> filters = ["All Chats", "Unread Chats"];
  String selectedFilter = "All Chats";
  InboxModel? inboxModel;
  List<Map<String, String>> allUsers = [
    {
      "name": "Athulya",
      "message": "Hey, how are you>",
      "unread": "5",
      "req_status": "Accepted",
      "time": "12:30 PM",
      "image": "assets/vectors/ath.jpeg",
      "recently_seen": "online",
    },
    {
      "name": "Kalidas",
      "message": "Hey, how are you>",
      "unread": "12",
      "req_status": "Pending",
      "time": "12:30 PM",
      "image": "assets/vectors/kalidas.jpeg",
      "recently_seen": "last seen 10:28",
    },
    {
      "name": "Suriya",
      "message": "Hai sir, how are you>",
      "unread": "0",
      "req_status": "Accepted",
      "time": "11:30 PM",
      "image": "assets/vectors/suriya3.jpg",
      "recently_seen": "online",
    },
    {
      "name": "Harsha Sreekanth",
      "message": "Hey, how are you>",
      "unread": "0",
      "req_status": "Accepted",
      "time": "02:30 PM",
      "image": "assets/vectors/harsha2.jpg",
      "recently_seen": "last seen 10:28",
    },
    {
      "name": "Druv Vikram",
      "message": "Hey, how are you>",
      "unread": "0",
      "req_status": "Pending",
      "time": "12:30 PM",
      "image": "assets/vectors/druv.jpg",
      "recently_seen": "last seen 05:18",
    },
    {
      "name": "Druv Vikram",
      "message": "Hey, how are you>",
      "unread": "0",
      "req_status": "Pending",
      "time": "12:30 PM",
      "image": "assets/vectors/druv.jpg",
      "recently_seen": "last seen 05:18",
    },
    {
      "name": "Druv Vikram",
      "message": "Hey, how are you>",
      "unread": "0",
      "req_status": "Pending",
      "time": "12:30 PM",
      "image": "assets/vectors/druv.jpg",
      "recently_seen": "last seen 05:18",
    },
    {
      "name": "Druv Vikram",
      "message": "Hey, how are you>",
      "unread": "0",
      "req_status": "Pending",
      "time": "12:30 PM",
      "image": "assets/vectors/druv.jpg",
      "recently_seen": "last seen 05:18",
    },
  ];
  List<Map<String, dynamic>> filteredUsers = [];
  List<Map<String, dynamic>> tempUsers = [];

  void filterUsers(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == "All Chats") {
        filteredUsers = tempUsers; // Show all users
      } else if (filter == "Unread Chats") {
        filteredUsers =
            tempUsers.where((user) => user["lastMessageByMe"] != true).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // filteredUsers = allUsers;
    fetchInboxUsers();
  }

  Future<void> fetchInboxUsers() async {
    // Simulate a network call to fetch inbox users
    print("Api called");
    await InboxService().getInboxUsers(context).then((value) {
      print(value);
      if (value != null) {
        setState(() {
          inboxModel = value;
          tempUsers = inboxModel!.inboxUser!
              .map((user) => {
                    "name": user.name!,
                    "image": user.image!,
                    "lastMessage": user.lastMessage!,
                    "unread": user.unreadMsgs,
                    "lastMessageTime": user.lastMessageTime!,
                    "lastMessageByMe": user.lastMessageByMe,
                    "unreadMsgs": user.unreadMsgs,
                  })
              .toList();
        });
        setState(() {
          filteredUsers = tempUsers; // Initially show all users
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text("Recent Chats"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          LightPinkGradient(),
          Positioned(
            bottom: 10,
            left: 0,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(3.14),
              child: Image.asset(
                "assets/vectors/dotted_design3.png",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Column(
            children: [
              // Top Filters of chats
              Container(
                width: MediaQuery.of(context).size.width,
                color: AppColors.softPink.withOpacity(0.4),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: filters.map((filter) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ChoiceChip(
                            selectedColor: AppColors.primaryRed,
                            checkmarkColor: AppColors.white,
                            labelStyle: TextStyle(
                                color: selectedFilter == filter
                                    ? AppColors.white
                                    : AppColors.black),
                            label: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(filter),
                            ),
                            selected: selectedFilter == filter,
                            onSelected: (bool selected) {
                              filterUsers(
                                  filter); // Apply the filter when the chip is selected
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          return InboxCard(user: filteredUsers[index]);
                        },
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
