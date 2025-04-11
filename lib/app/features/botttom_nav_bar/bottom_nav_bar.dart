import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/nav_controller.dart';
import 'screen/doctor_appoint_screen.dart';
import 'screen/document_store_screen.dart';
import 'screen/home_screen.dart';
import 'screen/profile_screen.dart';

class MainScreen extends StatelessWidget {
  final NavController navController = Get.put(NavController());

  final List<Widget> screens = [
    HomeScreen(),
    ProfileScreen(),
    DocumentScreen(),
    DoctorAppointmentScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          'Medi Guardian',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: screens[navController.currentIndex.value],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar('FAB', 'Floating Action Button Pressed');
        },
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
            onTap: (index) {
              navController.changeIndex(index);
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Docs'),
              BottomNavigationBarItem(icon: Icon(Icons.local_hospital), label: 'Doctor'),
            ],
          ),
        ),
      ),
      drawer: Drawer(),
    ));
  }
}
