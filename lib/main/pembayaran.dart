import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/main/index.dart';

class PaymentFormPage extends StatelessWidget {
  final String placeName;
  final String orderId;
  final DateTime selectedDate;
  final double totalPrice;
  final String selectedPaymentMethod;
  final String imgUrl;
  final int ticketCount;

  PaymentFormPage({
    required this.placeName,
    required this.orderId,
    required this.selectedDate,
    required this.totalPrice,
    required this.selectedPaymentMethod,
    required this.imgUrl,
    required this.ticketCount,
  });

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      CollectionReference orders =
          FirebaseFirestore.instance.collection('orders');
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Form Pembayaran',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xFF425C48),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Card(
                color: Color(0xFF425C48),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama Wisata',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            placeName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(
                color: Color(0xFF373A40),
                thickness: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID Order:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    orderId,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tiket:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$ticketCount',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tanggal:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Harga:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Rp ${totalPrice.toStringAsFixed(3)}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pembayaran:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    selectedPaymentMethod,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Color(0xFF373A40),
                thickness: 5,
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 300,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Scan QR Code untuk Pembayaran',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 10),
                          Image.asset(
                            'assets/images/qr.png',
                            height: 150,
                            width: 150,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      String? userEmail = user.email;

                      if (userEmail != null) {
                        try {
                          DocumentSnapshot userDoc =
                              await users.doc(user.uid).get();
                          String username = userDoc['username'];
                          String email = userDoc[
                              'email']; // Ensure the field name is correct

                          await orders.add({
                            'wisata': placeName,
                            'orderId': orderId,
                            'tanggal': selectedDate,
                            'jumlahTiket': ticketCount,
                            'totalHarga': totalPrice.toStringAsFixed(3),
                            'metodePembayaran': selectedPaymentMethod,
                            'userEmail': userEmail,
                            'imgUrl': imgUrl,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Pembayaran berhasil.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => IndexPage(
                                    username: username,
                                    email: email)), // Pass data to IndexPage
                          );
                        } catch (e) {
                          print('Error saving data: $e');

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Terjadi kesalahan. Silakan coba lagi.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Email pengguna tidak tersedia.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF425C48),
                    ),
                    child: Text(
                      'Selesai',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Text('Anda belum login.'),
        ),
      );
    }
  }
}
