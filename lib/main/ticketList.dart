import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketList extends StatelessWidget {
  final bool isCurrent;

  TicketList({required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      return Center(child: Text('Anda belum login.'));
    }

    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');
    Query ticketsQuery = orders.where('userEmail', isEqualTo: user.email);

    if (isCurrent) {
      ticketsQuery =
          ticketsQuery.where('tanggal', isGreaterThanOrEqualTo: DateTime.now());
    } else {
      ticketsQuery = ticketsQuery.where('tanggal', isLessThan: DateTime.now());
    }

    return StreamBuilder<QuerySnapshot>(
      stream: ticketsQuery.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No tickets found.'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var ticketData = snapshot.data!.docs[index];
            return Column(
              children: [
                TicketCard(ticketData: ticketData),
                if (index < snapshot.data!.docs.length - 1) ...[
                  SizedBox(height: 8),
                  TimelineDivider(),
                ],
              ],
            );
          },
        );
      },
    );
  }
}

class TicketCard extends StatelessWidget {
  final QueryDocumentSnapshot ticketData;

  TicketCard({required this.ticketData});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF425C48),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama Wisata',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  ticketData['wisata'],
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Date',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  '${ticketData['tanggal'].toDate().day}/${ticketData['tanggal'].toDate().month}/${ticketData['tanggal'].toDate().year}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Jumlah Tiket',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  '${ticketData['jumlahTiket']}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimelineDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var border = Border.all(color: Colors.grey);
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: border,
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
