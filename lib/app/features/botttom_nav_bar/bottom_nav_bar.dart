import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_gr_2_project/app/features/botttom_nav_bar/screen/add_medicine.dart';
import 'package:medi_gr_2_project/app/features/botttom_nav_bar/screen/profile_screen.dart';
import '../auth_section/controller/auth_controller.dart';
import 'controller/nav_controller.dart';
import 'screen/doctor_appoint_screen.dart';
import 'screen/document_store_screen.dart';
import 'screen/home_screen.dart';

class MainScreen extends StatelessWidget {
  final NavController navController = Get.put(NavController());
  final List<Widget> screens = [
    HomeScreen(),

    DocumentScreen(),
    AppointmentScreen(),
    ProfileScreen(),
  ];

  /// Returns a greeting message based on the current time of day.
  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return '🌅 Good Morning';
    } else if (hour < 17) {
      return '☀️ Good Afternoon';
    } else {
      return '🌇 Good Evening';
    }
  }


  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Obx(() => Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Obx(() {
          final userName = authController.userData["name"] ?? "User";
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_getGreeting()}, $userName',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'Medi Guardian',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          );
        }),
        centerTitle: false,
        backgroundColor: Colors.teal,
        elevation: 4,
        actions: [
          Obx(() {
            final profileImage = authController.profileImage.value;
            return GestureDetector(
              onTap: () => navController.changeIndex(1), // Navigate to profile
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage)
                      : null,
                  child: profileImage == null
                      ? Icon(Icons.person, color: Colors.white)
                      : null,
                  backgroundColor: profileImage == null ? Colors.teal[200] : null,
                ),
              ),
            );
          }),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: screens[navController.currentIndex.value],
        ),
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: () => Get.to(() => AddEditMedicineScreen()),
        backgroundColor: Colors.teal,
        child: Icon(Icons.add, size: 28),
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            elevation: 0,
            currentIndex: navController.currentIndex.value,
            onTap: (index) => navController.changeIndex(index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

              BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Docs'),
              BottomNavigationBarItem(icon: Icon(Icons.local_hospital), label: 'Doctor'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ),
      ),
    ));
  }
}