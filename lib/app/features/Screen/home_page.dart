import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/app_color.dart';
import 'deposit_screen.dart';

class EarningHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EarningPoint"),
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        actions: [
          IconButton(
            icon: Icon(Icons.currency_exchange),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Balance Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Your Balance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text("\$150.75", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> DepositScreen()));

                          },
                          icon: Icon(Icons.add_circle),
                          label: Text("Deposit"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.money),
                          label: Text("Withdraw"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            Text("Earning Options", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            SizedBox(height: 10),

            // Task List
            Expanded(
              child: ListView(
                children: [
                  _earningOption("Watch Ads", Icons.play_circle_filled, "\$0.50 per ad"),
                  _earningOption("Complete Surveys", Icons.poll, "\$2 per survey"),
                  _earningOption("Refer a Friend", Icons.group_add, "\$5 per referral"),
                  _earningOption("Daily Check-in", Icons.calendar_today, "\$0.25 per day"),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(LucideIcons.wallet), label: "Wallet"),
          BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: "Profile"),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _earningOption(String title, IconData icon, String subtitle) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 35, color: Colors.blue),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
