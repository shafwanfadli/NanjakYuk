import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/content/home.dart';
import 'index.dart';
import 'edit_user.dart';

class ProfilePage extends StatefulWidget {
  String username;
  String email;

  ProfilePage({super.key, required this.username, required this.email});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _username;
  late String _email;

  @override
  void initState() {
    super.initState();
    _username = widget.username;
    _email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Profile',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor:Color.fromRGBO(107,62,38,1), // Warna hijau
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => IndexPage(
                  username: _username.isNotEmpty ? _username : 'User',
                  email: _email.isNotEmpty ? _email : 'user@example.com',
                ),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/images/fp.png'), // Ganti dengan gambar profil
            ),
            const SizedBox(height: 10),
            Text(
              _username, // Gunakan parameter username
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF425C48), // Warna teks hijau
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _email, // Gunakan parameter email
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.edit,
                        color: const Color(0xFF425C48)), // Warna ikon hijau
                    title: const Text('Edit Profil'),
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: const Color(0xFF425C48)), // Warna ikon hijau
                    onTap: () async {
                      // Navigate to EditProfilePage
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            username: _username,
                            email: _email,
                          ),
                        ),
                      );

                      if (result != null && result is Map<String, String>) {
                        // Update the profile data with the result
                        setState(() {
                          _username = result['username']!;
                          _email = result['email']!;
                        });
                      }
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.security,
                        color: const Color(0xFF425C48)), // Warna ikon hijau
                    title: const Text('Pengaturan Keamanan'),
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: const Color(0xFF425C48)), // Warna ikon hijau
                    onTap: () {
                      // Aksi untuk pengaturan keamanan
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.help,
                        color: const Color(0xFF425C48)), // Warna ikon hijau
                    title: const Text('Bantuan'),
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: const Color(0xFF425C48)), // Warna ikon hijau
                    onTap: () {
                      // Aksi untuk bantuan
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  bool shouldLogout =
                      await _showLogoutConfirmationDialog(context);
                  if (shouldLogout) {
                    try {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Logout failed: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF425C48), // Warna tombol hijau
                ),
                child: const Text(
                  'Keluar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Konfirmasi Logout'),
              content: Text('Apakah Anda ingin logout?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Ya'),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if the dialog is dismissed by clicking outside of it
  }
}
