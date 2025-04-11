import 'package:flutter/material.dart';

class DepositScreen extends StatefulWidget {
  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _transactionController = TextEditingController();
  String _selectedBkashType = "Personal"; // Default type

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _numberController.dispose();
    _transactionController.dispose();
    super.dispose();
  }

  void _confirmDeposit() {
    if (_formKey.currentState!.validate()) {
      String paymentMethod = ["Bkash", "Nagad", "Rocket", "Mastercard"][_tabController.index];

      print("Payment Method: $paymentMethod");
      print("Number: ${_numberController.text}");
      print("Transaction ID: ${_transactionController.text}");
      print("Bkash Type: $_selectedBkashType");

      // TODO: Send data to backend API for deposit confirmation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Deposit Money")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // TabBar for Payment Methods
            TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              indicator: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(40)),
              tabs: [
                Tab(text: "Bkash"),
                Tab(text: "Nagad"),
                Tab(text: "Rocket"),
                Tab(text: "Mastercard"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBkashForm(),   // Bkash Deposit
                  _buildNagatForm(),  // Nagad Deposit
                  _buildRocketForm(), // Rocket Deposit
                  _buildCommonForm("Mastercard"), // Mastercard Deposit
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Form for Bkash Deposit
  Widget _buildBkashForm() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.pink ,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
              )
            ),
            height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Bkash Number Personal",style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),),
                  SizedBox(height: 10,),
                  SelectableText(
                    "01701577479",

                    style: TextStyle(
                    fontSize: 20
                  ),)
                ],
              ),
            ),
            TextFormField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Payment Bkash Number"),
              validator: (value) => value!.isEmpty ? "Enter your Bkash Number" : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _transactionController,
              decoration: InputDecoration(labelText: "Payment Transaction ID"),
              validator: (value) => value!.isEmpty ? "Enter Transaction ID" : null,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedBkashType,
              decoration: InputDecoration(labelText: "Bkash Type"),
              items: ["Personal", "Agent", "Merchant"].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) => setState(() => _selectedBkashType = value!),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmDeposit,
              child: Text("Confirm Deposit"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildNagatForm() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.deepOrange ,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
              )
            ),
            height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Nagat Number Personal",style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),),
                  SizedBox(height: 10,),
                  SelectableText(
                    "01701577479",

                    style: TextStyle(
                    fontSize: 20
                  ),)
                ],
              ),
            ),
            TextFormField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Payment Nagat Number"),
              validator: (value) => value!.isEmpty ? "Enter your Nagat Number" : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _transactionController,
              decoration: InputDecoration(labelText: "Payment Transaction ID"),
              validator: (value) => value!.isEmpty ? "Enter Transaction ID" : null,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedBkashType,
              decoration: InputDecoration(labelText: "Nagat Type"),
              items: ["Personal", "Agent", "Merchant"].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) => setState(() => _selectedBkashType = value!),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmDeposit,
              child: Text("Confirm Deposit"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildRocketForm() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent ,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
              )
            ),
            height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Rocket Number Personal",style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),),
                  SizedBox(height: 10,),
                  SelectableText(
                    "017015774791",

                    style: TextStyle(
                    fontSize: 20
                  ),)
                ],
              ),
            ),
            TextFormField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Payment Rocket Number"),
              validator: (value) => value!.isEmpty ? "Enter your Rocket Number" : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _transactionController,
              decoration: InputDecoration(labelText: "Payment Transaction ID"),
              validator: (value) => value!.isEmpty ? "Enter Transaction ID" : null,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedBkashType,
              decoration: InputDecoration(labelText: "Rocket Type"),
              items: ["Personal", "Agent", "Merchant"].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) => setState(() => _selectedBkashType = value!),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmDeposit,
              child: Text("Confirm Deposit"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Form for Nagad, Rocket, Mastercard
  Widget _buildCommonForm(String method) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "$method Number"),
              validator: (value) => value!.isEmpty ? "Enter your $method Number" : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _transactionController,
              decoration: InputDecoration(labelText: "Transaction ID"),
              validator: (value) => value!.isEmpty ? "Enter Transaction ID" : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmDeposit,
              child: Text("Confirm Deposit"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
