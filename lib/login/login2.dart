import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/main/index.dart'; // Import halaman index

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Jika login berhasil, navigasi ke halaman index
      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successful!'),
            backgroundColor:
                Colors.green, // Warna hijau untuk snackbar berhasil
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                IndexPage(), // Ganti dengan halaman yang sesuai
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed, user not found.'),
            backgroundColor: Colors.red, // Warna merah untuk snackbar gagal
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $e'),
          backgroundColor: Colors.red, // Warna merah untuk snackbar gagal
        ),
      );
      // Log the error to the console
      print('Login failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFED), // Ganti warna latar belakang
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo at the top
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png', // Path to your logo image
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Email and password fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    obscureText: true, // Hide the password
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Login button
            SizedBox(
              width: 320, // Atur lebar tombol
              height: 50, // Atur tinggi tombol
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF425C48), // Ganti warna tombol
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white), // Ganti warna teks
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Already have an account text with navigation
            GestureDetector(
              onTap: () {
                // Navigate to the registration page
                Navigator.pushNamed(context, '/register');
              },
              child: RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: const TextStyle(color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign up',
                      style: const TextStyle(
                        color: Colors.blue, // Warna teks "Sign up"
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
