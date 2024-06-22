import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/main/index.dart';

class DetailTicketPage extends StatelessWidget {
  final Map<String, dynamic> tiketData;
  final String orderId;

  DetailTicketPage({required this.tiketData, required this.orderId});

  @override
  Widget build(BuildContext context) {
    DateTime tanggal = (tiketData['tanggal'] as Timestamp).toDate();

    Future<void> deleteTicket() async {
      try {
        // Periksa apakah pengguna telah terautentikasi
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw 'Pengguna belum masuk.';
        }

        // Ambil data pengguna dari Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          throw 'Data pengguna tidak ditemukan.';
        }

        // Ambil username dan email dari dokumen pengguna
        String username = userDoc['username'];
        String email = userDoc['email'];

        // Menghapus dokumen dari koleksi 'orders'
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tiket berhasil dibatalkan!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  IndexPage(username: username, email: email)),
        );
      } catch (e) {
        print('Error deleting ticket: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membatalkan tiket: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Tiket',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF425C48),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  tiketData['imgUrl'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
                Positioned(
                  bottom: 2,
                  left: 13,
                  child: Text(
                    '${tiketData['wisata']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(66, 92, 72, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tanggal:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        '${tanggal.day}/${tanggal.month}/${tanggal.year}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Jumlah Tiket:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        '${tiketData['jumlahTiket']}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Card(
              color: Color.fromRGBO(66, 92, 72, 1),
              child: Padding(
                padding:
                    const EdgeInsets.all(10.0), // Ubah ukuran padding di sini
                child: Image.asset(
                  'assets/images/qr.png',
                  height: 250,
                  width: 400, // Ubah ukuran width di sini
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 400,
              child: ElevatedButton(
                onPressed: deleteTicket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(66, 92, 72, 1),
                ),
                child: Text(
                  'Batalkan pemesanan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
