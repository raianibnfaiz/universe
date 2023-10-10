import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/City.dart';
import '../models/State.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key,required this.onClose});
  final VoidCallback onClose;

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
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
  final _auth = FirebaseAuth.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String? _selectedDivision;
  String? _selectedDistrict;
  @override
  void initState() {
    super.initState();

    // Fetch user data from Firestore
    fetchUserData();
  }
  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;
    // Assuming 'users' is the collection and 'user_id' is the document ID
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    if (userSnapshot.exists) {
      setState(() {
        _usernameController.text = userSnapshot['username'];
        _phoneNumberController.text = userSnapshot['phone'];
        _selectedDivision = userSnapshot['division'] ?? 'Select Division';
        _selectedDistrict = userSnapshot['district']?? 'Select District';
      });
    }
  }
  Future<void> updateUserData() async {
    User? user = _auth.currentUser;
    // Update user data in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .update({
      'username': _usernameController.text,
      'phone': _phoneNumberController.text,
      'division': _selectedDivision,
      'district': _selectedDistrict,
    });
    final userdocs = await FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: user?.uid).get();
    if(userdocs.docs.isNotEmpty) {
      userdocs.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(element.id)
            .update({
          'username': _usernameController.text,
        });
      });
    }
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return  Padding(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                  ),
                ),
                SizedBox(height: 20.0),
                DropdownButton<String>(
                  value: _selectedDivision ?? 'Select Division',
                  onChanged: (newValue) {
                    setState(() {
                      _selectedDivision = newValue != 'Select Division' ? newValue : null;
                      _selectedDistrict = null; // Reset selectedDistrict when division changes
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: 'Select Division',
                      child: Text('Select Division'),
                    ),
                    if (states.isNotEmpty)
                      ...states.map((state) {
                        return DropdownMenuItem<String>(
                          value: state.name,
                          child: Text(state.name),
                        );
                      }),
                  ],
                ),
                DropdownButton<String>(
                  value: _selectedDistrict ?? 'Select District',
                  onChanged: (newValue) {
                    setState(() {
                      _selectedDistrict = newValue != 'Select District' ? newValue : null;
                    });
                  },
                  items: _selectedDivision != null
                      ? [
                    DropdownMenuItem<String>(
                      value: 'Select District',
                      child: Text('Select District'),
                    ),
                    if (states.isNotEmpty && _selectedDivision != null)
                      ...states
                          .firstWhere(
                            (state) => state.name == _selectedDivision,
                        orElse: () => Divisions('Empty', []),
                      )
                          .cities
                          .map((city) {
                        return DropdownMenuItem<String>(
                          value: city.name,
                          child: Text(city.name),
                        );
                      }),
                  ]
                      : [
                    DropdownMenuItem<String>(
                      value: 'Select District',
                      child: Text('Select District'),
                    ),
                  ],
                ),

                SizedBox(height: 30),
                /*ElevatedButton(
                  onPressed: () {
                    updateUserData();
                  },
                  child: Text('Update'),
                ),*/
                ElevatedButton(

                  onPressed: (){updateUserData();},
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

        ],
      ),
    );
  }
}
