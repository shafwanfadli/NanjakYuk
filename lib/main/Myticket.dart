import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/main/detail_ticket.dart';

class MyTicketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      CollectionReference orders =
          FirebaseFirestore.instance.collection('orders');

      return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Tickets',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF425C48),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: orders.where('userEmail', isEqualTo: user.email).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var document = snapshot.data!.docs[index];
                  var data = document.data() as Map<String, dynamic>;
                  String orderId = document.id; // Get the document ID
                  DateTime tanggal = (data['tanggal'] as Timestamp)
                      .toDate(); // Konversi Timestamp ke DateTime

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: Card(
                      color: Color.fromRGBO(66, 92, 72, 1), // Background color
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          // Wrap Card dengan InkWell untuk membuatnya bisa diklik
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailTicketPage(
                                    tiketData: data, orderId: orderId),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(data['imgUrl']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Colors.white),
                                      SizedBox(width: 4),
                                      Text(
                                        data['wisata'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.date_range,
                                          color: Colors.white),
                                      SizedBox(width: 4),
                                      Text(
                                        '${tanggal.day}/${tanggal.month}/${tanggal.year}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.confirmation_number,
                                          color: Colors.white),
                                      SizedBox(width: 4),
                                      Text(
                                        '${data['jumlahTiket']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'Belum ada tiket yang dipesan.',
                  style: TextStyle(
                      color: Colors.white), // Ubah warna font jadi putih
                ),
              );
            }
          },
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Text(
            'Anda belum login.',
            style: TextStyle(color: Colors.white), // Ubah warna font jadi putih
          ),
        ),
      );
    }
  }
}
