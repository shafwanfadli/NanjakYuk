import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  final String username;
  final String email;

  EditProfilePage({required this.username, required this.email});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _email;

  @override
  void initState() {
    super.initState();
    _username = widget.username;
    _email = widget.email;
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        String userId =
            FirebaseAuth.instance.currentUser!.uid; // Get current user's UID
        // Update Firestore with the new username and email
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId) // Use UID as document ID
            .update({
          'username': _username,
          'email': _email,
          // 'email': _email, // Email tidak perlu diubah jika sudah ada
        });

        Navigator.pop(context, {'username': _username, 'email': _email});
      } catch (e) {
        print('Error updating profile: $e');
        // Handle error updating profile (e.g., show error message)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor:Color.fromRGBO(107,62,38,1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Add spacing above the logo image
              SizedBox(height: 100),
              Center(
                child: Image.asset(
                  'assets/images/fp.png',
                  width: 150, // Adjust the width as needed
                  height: 150, // Adjust the height as needed
                ),
              ),
              SizedBox(height: 20),
              // Wrap the username TextFormField in a Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: _username,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: InputBorder.none, // Remove default border
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _username = value!;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Wrap the email TextFormField in a Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: _email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: InputBorder.none, // Remove default border
                    ),
                    enabled: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.white), // Set the text color to white
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(107,62,38,1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
