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
  int ticketCount = 1;
  double totalPrice = 0.0;
  DateTime selectedDate = DateTime.now();
  String selectedPaymentMethod = 'QRIS';
  final List<String> paymentMethods = [
    'E-Wallet',
    'QRIS',
    'Bank Transfer',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.place != null) {
      calculateTotalPrice();
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
        totalPrice = 0.0;
      }
    }
  }

  void incrementTicketCount() {
    setState(() {
      ticketCount++;
      calculateTotalPrice();
    });
  }

  void decrementTicketCount() {
    setState(() {
      if (ticketCount > 1) ticketCount--;
      calculateTotalPrice();
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
    String imgUrl = widget.place.imageUrl;

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
          ticketCount: ticketCount,
        ),
      ),
    );

    if (paymentSuccess) {
      // Handle payment success
    } else {
      // Handle payment failure or cancellation
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
        backgroundColor:Color.fromRGBO(107,62,38,1),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detail Pesanan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Card(
                color: Color(0xFF425C48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          widget.place.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.place.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Harga Per Tiket: Rp ${widget.place.price}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: Color(0xFF425C48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: decrementTicketCount,
                        icon: Icon(Icons.remove, color: Colors.white),
                      ),
                      Text(
                        '$ticketCount',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      IconButton(
                        onPressed: incrementTicketCount,
                        icon: Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: Color(0xFF425C48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Harga',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Rp ${totalPrice.toStringAsFixed(3)}',
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
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Card(
                  color: Color(0xFF425C48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pilih Tanggal',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.white),
                            SizedBox(width: 8),
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
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: Color(0xFF425C48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Metode Pembayaran',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
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
                              child: Row(
                                children: [
                                  Icon(
                                    method == 'E-Wallet'
                                        ? Icons.account_balance_wallet
                                        : method == 'QRIS'
                                            ? Icons.qr_code
                                            : Icons.account_balance,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    method,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _navigateToPaymentForm,
                  icon: Icon(Icons.payment, color: Colors.white),
                  label: Text(
                    'Checkout',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF425C48),
                    padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
