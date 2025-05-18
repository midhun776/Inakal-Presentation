import 'package:flutter/material.dart';
import 'package:inakal/constants/app_constants.dart';

class InboxCard extends StatefulWidget {
  Map<String, dynamic> user;
  InboxCard({
    super.key,
    required this.user,
  });

  @override
  State<InboxCard> createState() => _InboxCardState();
}

class _InboxCardState extends State<InboxCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("User: ${widget.user}");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.user["lastMessageByMe"] == true
              ? const Color.fromARGB(255, 235, 235, 235)
              : AppColors.readMsg,
        ),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(widget.user["image"]!),
                      ),
                      if (widget.user["lastMessageByMe"] == true)
                        Positioned(
                            bottom: 4,
                            right: 4,
                            child: Icon(Icons.circle,
                                color: AppColors.vibrantGreen, size: 10)),
                    ],
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.user["name"] ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Row(
                        children: [
                          if (widget.user["lastMessageByMe"] == true)
                            Row(
                              children: [
                                Icon(
                                  Icons.done_all_rounded,
                                  size: 20,
                                ),
                                SizedBox(width: 5),
                              ],
                            ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              widget.user["lastMessage"] ?? "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(widget.user["lastMessageTime"]!),
                      Opacity(
                        opacity: widget.user["lastMessageByMe"] == true ? 0 : 1,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.primaryRed,
                          child: Text(widget.user["unreadMsgs"].toString(),
                              style: TextStyle(
                                  color: AppColors.white, fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
