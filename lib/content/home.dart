import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Transform.translate(
            offset: const Offset(0, -120), // Menggeser background ke atas
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/background.jpg'), // Path to your background image
                  fit: BoxFit.cover,
                  alignment:
                      Alignment.topCenter, // Atur alignment background ke atas
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Menambahkan Spacer atau SizedBox untuk mendorong teks ke atas
                const Spacer(flex: 1), // Spacer dengan flex 1
                Container(
                  margin: const EdgeInsets.only(left: 27), // Atur margin kiri
                  child: const Text(
                    'Explore Baturaden With Us.',
                    style: TextStyle(
                      fontFamily: 'SFProText',
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: 345, // Tentukan lebar yang diinginkan
                  height: 65,
                  child: const Text(
                    'We Travelin are ready to help you on vacation around Indonesia',
                    style: TextStyle(
                      fontFamily: 'SFProText',
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(flex: 3), // Spacer dengan flex 3
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 150, // Tentukan tinggi yang diinginkan
              decoration: const BoxDecoration(
                color: Colors.white, // Warna dan opacity untuk rectangle
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), // Radius pada sudut kiri atas
                  topRight: Radius.circular(25), // Radius pada sudut kanan atas
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 250, // Tentukan lebar tombol yang diinginkan
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigasi ke halaman login
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        backgroundColor: const Color(0xFF425C48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ), // Atur warna tombol
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Let\'s Get Started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10, // Tambahkan jarak antara button dan teks
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman register
                      Navigator.pushNamed(context, '/register');
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: const TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Register',
                            style: const TextStyle(
                              color: Colors.blue, // Warna teks "Register"
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
          ),
        ],
      ),
    );
  }
}
