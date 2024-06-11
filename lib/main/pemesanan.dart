import 'package:flutter/material.dart';
import 'package:flutter_application_1/main/pembayaran.dart';
import 'package:uuid/uuid.dart';
import 'places.dart';

class OrderPage extends StatefulWidget {
  final Place place;

  OrderPage({required this.place});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int ticketCount = 1; // Jumlah tiket awal
  double totalPrice = 0.0; // Total harga awal
  DateTime selectedDate = DateTime.now(); // Tanggal terpilih
  String selectedPaymentMethod = 'QRIS'; // Metode pembayaran terpilih
  final List<String> paymentMethods = [
    'E-Wallet',
    'QRIS',
    'bank',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.place != null) {
      calculateTotalPrice(); // Memanggil fungsi untuk menghitung total harga jika widget.place tidak null
    }
  }

  void calculateTotalPrice() {
    if (widget.place.price != null) {
      String priceString = widget.place.price!;
      try {
        double parsedPrice = double.parse(priceString);
        totalPrice = parsedPrice * ticketCount;
      } catch (e) {
        print('Error parsing price: $e');
        totalPrice = 0.0; // Atur nilai default jika parsing gagal
      }
    }
  }

  void incrementTicketCount() {
    setState(() {
      ticketCount++;
      calculateTotalPrice(); // Memanggil fungsi untuk menghitung total harga
    });
  }

  void decrementTicketCount() {
    setState(() {
      if (ticketCount > 1) ticketCount--;
      calculateTotalPrice(); // Memanggil fungsi untuk menghitung total harga
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _navigateToPaymentForm() async {
    var uuid = Uuid();
    String orderId = uuid.v4().substring(0, 6);

    // Kirim imgUrl ke PaymentFormPage
    String imgUrl = widget.place.imageUrl;

    // Navigasi ke PaymentFormPage dan kirim data
    bool paymentSuccess = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentFormPage(
          placeName: widget.place.name,
          orderId: orderId,
          selectedDate: selectedDate,
          totalPrice: totalPrice,
          selectedPaymentMethod: selectedPaymentMethod,
          imgUrl: imgUrl,
          ticketCount: ticketCount, // Kirim nilai imgUrl ke PaymentFormPage
        ),
      ),
    );

    // Handle jika pembayaran berhasil
    if (paymentSuccess) {
      // Lakukan sesuatu setelah pembayaran berhasil
    } else {
      // Lakukan sesuatu jika pembayaran gagal atau dibatalkan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ringkasan Pemesanan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF425C48), // Ubah warna AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Pesanan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Card(
              color: Color(0xFF425C48), // Warna card hijau
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Image.network(
                          widget.place.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.place.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:
                                    Colors.white, // Ubah warna teks nama wisata
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Harga Per tiket: Rp ${widget.place.price}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors
                                    .white, // Ubah warna teks price per tiket
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            decrementTicketCount();
                          },
                          icon: Icon(Icons.remove),
                          color: Colors.white, // Ubah warna icon button
                        ),
                        Text(
                          '$ticketCount',
                          style: TextStyle(
                            color: Colors
                                .white, // Ubah warna teks angka pada button tiket count
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            incrementTicketCount();
                          },
                          icon: Icon(Icons.add),
                          color: Colors.white, // Ubah warna icon button
                        ),
                      ],
                    ),
                  ),
                  // Spasi sebelum Total Price
                ],
              ),
            ),
            SizedBox(height: 14), // Tambahkan jarak antara card

            Card(
              color: Color(0xFF425C48), // Warna card hijau
              child: SizedBox(
                width: double.infinity, // Atur lebar card menjadi sepanjang
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),
                  // Tambahkan margin atas 10.0,
                  child: Text(
                    'Total Harga: Rp ${totalPrice.toStringAsFixed(3)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Ubah warna teks total price
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Card(
                color: Color(0xFF425C48), // Warna card hijau
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pilih tanggal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ), // Tambahkan jarak antara card
            Card(
              color: Color(0xFF425C48), // Warna card hijau
              child: SizedBox(
                width: double
                    .infinity, // Atur lebar card menjadi sepanjang total price
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih metode pembayaran',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButton<String>(
                        value: selectedPaymentMethod,
                        dropdownColor: Color(0xFF425C48),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPaymentMethod = newValue!;
                          });
                        },
                        items: paymentMethods.map<DropdownMenuItem<String>>(
                          (String method) {
                            return DropdownMenuItem<String>(
                              value: method,
                              child: Text(
                                method,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _navigateToPaymentForm,
              child: Text(
                'Checkout',
                textAlign: TextAlign.center, // Teks di tengah secara horizontal
                style: TextStyle(
                  color: Colors.white, // Ubah warna teks menjadi putih
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF425C48),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                textStyle: TextStyle(fontSize: 18),
                fixedSize: Size.fromWidth(MediaQuery.of(context).size.width *
                    0.9), // Lebar sesuai dengan 90% lebar layar
              ),
            ),
          ],
        ),
      ),
    );
  }
}
