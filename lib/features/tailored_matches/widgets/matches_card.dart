import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inakal/constants/app_constants.dart';
import 'package:shimmer/shimmer.dart';

class MatchesCard extends StatelessWidget {
  const MatchesCard({super.key, required this.image, required this.name, required this.designation});
  final String image;
  final String name;
  final String designation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5 - 30,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Card(
            color: AppColors.white,
            clipBehavior: Clip.hardEdge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.5 - 30,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: AppColors.grey,
                      highlightColor: AppColors.lightGrey,
                      child: Container(
                        color: AppColors.grey,
                      ),
                    ),
                errorWidget: (context, url, error) => CachedNetworkImage(
                    imageUrl:
                        "https://i.pinimg.com/736x/dc/9c/61/dc9c614e3007080a5aff36aebb949474.jpg",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity)
                  )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1),
                      // SizedBox(height: 5),
                      Text(designation,
                          style: TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
