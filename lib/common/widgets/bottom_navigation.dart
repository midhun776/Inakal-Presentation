import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart'; // Material Design Icons
import 'package:inakal/common/controller/user_data_controller.dart';
import 'package:inakal/common/model/user_data_model.dart';
import 'package:inakal/constants/app_constants.dart';
import 'package:inakal/constants/config.dart';
import 'package:http/http.dart' as http;
import 'package:inakal/features/home/screens/home_screen.dart';
import 'package:inakal/features/profile/screens/profile_screen.dart';
import 'package:inakal/features/psychologists_listing/screens/counsellors_screen.dart';
import 'package:inakal/features/requests/screens/request_listing_screen.dart';
import 'package:inakal/features/tailored_matches/screens/matches_screen.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDataToGetx();
  }

  Future<void> fetchDataToGetx() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      final request = http.MultipartRequest('POST', Uri.parse(userProfileUrl));
      final headers = {
        'Authorization': 'Bearer $token',
      };
      request.headers.addAll(headers);
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);

        final userModel = UserDataModel.fromJson(jsonResponse);

        final userController = Get.find<UserDataController>();
        userController.setUserData(userModel);
      } else {
        print("Failed to fetch user profile");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          const HomeScreen(),
          CounsellorsScreen(),  
          MatchesScreen(),
          const RequestListingScreen(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: SnakeShape.circle,
        padding: const EdgeInsets.all(8),
        snakeViewColor: AppColors.primaryRed,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 255, 0, 38),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Iconify(
              color: _selectedIndex == 0 ? AppColors.white : AppColors.primaryRed,
              Mdi.cards, // Home icon
              size: 24,
            ),
            label: 'Home',
          ),
           BottomNavigationBarItem(
            icon: FaIcon(
            color: _selectedIndex == 1 ? AppColors.white : AppColors.primaryRed,
              FontAwesomeIcons.userDoctor, // Psychologists icon
              size: 24,
            ),
            label: 'Psychologists',
          ),
           BottomNavigationBarItem(
            icon: Iconify(
            color: _selectedIndex == 2 ? AppColors.white : AppColors.primaryRed,

              Mdi.heart, // Matches icon
              size: 28,
            ),
            label: 'Matches',
          ),
           BottomNavigationBarItem(
            icon: FaIcon(
            color: _selectedIndex == 3 ? AppColors.white : AppColors.primaryRed,
              FontAwesomeIcons.solidMessage, // Psychologists icon
              size: 24,
            ),
            label: 'Requests',
          ),
           BottomNavigationBarItem(
            icon: Iconify(
            color: _selectedIndex == 4 ? AppColors.white : AppColors.primaryRed,

              Mdi.user, // Profile icon
              size: 28,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
