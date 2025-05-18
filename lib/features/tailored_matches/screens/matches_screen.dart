import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:inakal/constants/app_constants.dart';
import 'package:inakal/constants/widgets/light_pink_gradient.dart';
import 'package:inakal/constants/widgets/light_pink_gradient_from_top.dart';
import 'package:inakal/features/tailored_matches/service/suggested_matches_service.dart';
import 'package:inakal/features/tailored_matches/widgets/matchcard_widget.dart';
import 'package:inakal/features/tailored_matches/widgets/matches_card.dart';
import 'package:lottie/lottie.dart';

class MatchesScreen extends StatefulWidget {
  MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final List<Map<String, String>> matches = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSuggestedMatches();
  }

  Future<void> fetchSuggestedMatches() async {
    await SuggestedMatchesService().getSuggestedMatches().then((value) {
      if (value.suggestedMatches != null) {
        for (var match in value.suggestedMatches!) {
          matches.add({
            'image': match.image!,
            'name': match.name!,
            'designation': match.location!,
          });
        }
      }
    }).catchError((error) {
      print("Error fetching suggested matches: $error");
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          const LightPinkGradientFromTop(),
          Positioned(
            top: -30,
            left: 15,
            child: Transform.rotate(
              angle: -0.3,
              child: Image.asset(
                "assets/vectors/dotted_design1.png",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Tailored  ',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              TextSpan(
                                text: 'Matches',
                                style: TextStyle(
                                  color: AppColors.primaryRed,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Transform.rotate(
                          angle: 0.5,
                          child: const Align(
                            child: Opacity(
                              opacity: 0.6,
                              child: Iconify(
                                Ph.butterfly_duotone,
                                size: 16,
                                color: AppColors.primaryRed,
                              ),
                            ),
                            alignment: Alignment.topRight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text(
                        "Discover personalized profiles thoughtfully curated by expert counselors, perfectly aligned with your interests and preferences for meaningful connections."),
                    const SizedBox(height: 15),
                    isLoading
                        ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryRed,
                              ),
                            ),
                        )
                        : matches.isEmpty
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.5, // Adjust based on how much header content there is
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Lottie.asset(
                                        "assets/lottie/empty_data.json",
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "No Matches Found",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Wrap(
                                spacing: 5.0,
                                runSpacing: 5.0,
                                children: matches.map((match) {
                                  return MatchesCard(
                                    image: match['image']!,
                                    name: match['name']!,
                                    designation: match['designation']!,
                                  );
                                }).toList(),
                              ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
