import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/City.dart';
import '../models/State.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key,required this.onClose});
  final VoidCallback onClose;
  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
  final _auth = FirebaseAuth.instance;

  String? _userName;
  String? _userEmail;
  String? _userPhotoUrl;
  String? _selectedState;
  String? _selectedCity;
  final List<Divisions> states = [
    Divisions('Dhaka', [Districts('Dhaka'), Districts(' Faridpur'), Districts(' Gazipur'), Districts(' Gopalganj'), Districts(' Jamalpur'), Districts(' Kishoreganj'), Districts(' Madaripur'), Districts(' Manikganj'), Districts(' Munshiganj'), Districts(' Mymensingh'), Districts(' Narayanganj'), Districts(' Narsingdi'), Districts(' Netrakona'), Districts(' Rajbari'), Districts(' Shariatpur'), Districts(' Sherpur'), Districts(' Tangail')]),
    Divisions('Chattogram', [Districts('Bandarban'), Districts(' Brahmanbaria'), Districts(' Chandpur'), Districts(' Chattogram'), Districts(' Cumilla'), Districts(' Cox’s Bazar'), Districts(' Feni'), Districts(' Khagrachhari'), Districts(' Lakshmipur'), Districts(' Noakhali'), Districts(' Rangamati')]),
    Divisions('Rajshahi', [Districts('Bogra'), Districts(' Chapainawabganj'), Districts(' Joypurhat'), Districts(' Naogaon'), Districts(' Natore'), Districts(' Pabna'), Districts(' Rajshahi'), Districts(' Sirajganj')]),
    Divisions('Khulna', [Districts('Bagerhat'), Districts(' Chuadanga'), Districts(' Jashore'), Districts(' Jhenaidah'), Districts(' Khulna'), Districts(' Kushtia'), Districts(' Magura'), Districts(' Meherpur'), Districts(' Narail'), Districts(' Satkhira')]),
    Divisions('Barishal', [Districts('Barguna'), Districts(' Barishal'), Districts(' Bhola'), Districts(' Jhalokati'), Districts(' Patuakhali'), Districts(' Pirojpur')]),
    Divisions('Sylhet', [Districts('Habiganj'), Districts(' Moulvibazar'), Districts(' Sunamganj'), Districts(' Sylhet')]),
    Divisions('Mymensingh', [Districts('Jamalpur'), Districts(' Netrokona'), Districts(' Sherpur'), Districts(' Mymensingh')]),
    Divisions('Rangpur', [Districts('Dinajpur'), Districts(' Gaibandha'), Districts(' Kurigram'), Districts(' Lalmonirhat'), Districts(' Nilphamari'), Districts(' Panchagarh'), Districts(' Rangpur'), Districts(' Thakurgaon')]),
    // Add more states and cities as needed
  ];


  @override
  void initState() {
    super.initState();
    _getUserInfo();
    print("photo URL $_userPhotoUrl");
  }

  Future<void> _getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.displayName;
        _userEmail = user.email;
        _userPhotoUrl = user.photoURL;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 40),
           // Adjust the width as needed
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              IconButton(
                onPressed: widget.onClose,
                icon: Icon(Icons.close),
              ),
              Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 40), // Adjust the width as needed
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),

                  _userPhotoUrl != null
                      ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(_userPhotoUrl!),
                  )
                      : SizedBox(), // Hide if photo URL is null

                  SizedBox(height: 20),

                  _userName != null
                      ? Text(
                    '$_userName',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : SizedBox(), // Hide if username is null

                  SizedBox(height: 10),

                  _userEmail != null
                      ? Text(
                    '$_userEmail',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  )
                      : SizedBox(), // Hide if email is null

                  SizedBox(height: 30),

                  DropdownButton<String>(
                    value: _selectedState,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedState = newValue;
                        // Reset the selected city when state changes
                        _selectedCity = null;
                      });
                    },
                    items: states.map((state) {
                      return DropdownMenuItem<String>(
                        value: state.name,
                        child: Text(state.name),
                      );
                    }).toList(),
                    hint: Text('Select Division'),
                  ),

                  SizedBox(height: 20),

                  DropdownButton<String>(
                    value: _selectedCity,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCity = newValue;
                      });
                    },
                    items: _selectedState != null
                        ? states
                        .firstWhere((state) => state.name == _selectedState)
                        .cities
                        .map((city) {
                      return DropdownMenuItem<String>(
                        value: city.name,
                        child: Text(city.name),
                      );
                    }).toList()
                        : [],
                    hint: Text('Select District'),
                  ),

                  SizedBox(height: 30),


                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrangeAccent, // Background color
                      onPrimary: Colors.white, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Rounded corners
                      ),
                      elevation: 3, // Elevation to create a shadow effect
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0), // Rounded corners for ink splash
                      ),
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 150.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Update',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}