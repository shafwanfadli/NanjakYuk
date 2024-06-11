import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_application_1/main/Myticket.dart';
import 'package:flutter_application_1/main/detail_page.dart';
import 'package:flutter_application_1/main/places.dart';
import 'package:flutter_application_1/main/profil_user.dart';

class Places {
  final String name;
  final String imageUrl;
  final double rating;
  final String location;
  final String price;

  Places({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.location,
    required this.price,
  });

  factory Places.fromJson(Map<String, dynamic> json) {
    return Places(
      name: json['name'],
      imageUrl: json['imageUrl'],
      rating: json['rating'].toDouble(),
      location: json['location'],
      price: json['price'],
    );
  }
}

class IndexPage extends StatefulWidget {
  final String? username;
  final String? email;

  const IndexPage({Key? key, this.username, this.email}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  late Future<List<Place>> places;
  String searchQuery = '';

  Future<List<Place>> fetchPlaces() async {
    final response =
        await rootBundle.rootBundle.loadString('assets/places.json');
    List jsonResponse = json.decode(response);
    return jsonResponse.map((place) => Place.fromJson(place)).toList();
  }

  @override
  void initState() {
    super.initState();
    places = fetchPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 235, 233),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(66, 92, 72, 1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.username != null ? widget.username! : 'User',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Mau kemana hari ini?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value.toLowerCase();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Cari tempat wisata',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Popular place',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              FutureBuilder<List<Place>>(
                future: places,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load places'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No places available'));
                  } else {
                    List<Place> filteredPlaces = snapshot.data!
                        .take(3)
                        .toList()
                        .where((place) =>
                            place.name.toLowerCase().contains(searchQuery))
                        .toList();
                    return Container(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredPlaces.length,
                        itemBuilder: (context, index) {
                          Place place = filteredPlaces[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPage(place: place),
                                  ),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  width: 170,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                        child: Image.network(
                                          place.imageUrl,
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              place.name,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: 16,
                                                ),
                                                Text('${place.rating}'),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Harga: Rp ${place.price}',
                                                ),
                                              ],
                                            ),
                                            Text(place.location),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rekomendation for you',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<Place>>(
                future: places,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load places'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No places available'));
                  } else {
                    // Filter places based on search query
                    List<Place> filteredPlaces = snapshot.data!
                        .skip(3)
                        .take(3)
                        .toList()
                        .where((place) => place.name
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredPlaces.length,
                      itemBuilder: (context, index) {
                        Place place = filteredPlaces[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(place: place),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        place.imageUrl,
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          place.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(place.location),
                                        Row(
                                          children: [
                                            Text(
                                              'Harga: Rp ${place.price}',
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 16,
                                            ),
                                            Text(
                                                '${place.rating} (1000 reviews)'),
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
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF425C48),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons
                .confirmation_number), // Mengganti ikon search dengan ikon tiket
            label: 'Tickets', // Mengganti label dari "Search" menjadi "Tickets"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  username: widget.username ??
                      'default username', // Ganti dengan nilai username sebenarnya
                  email: widget.email ??
                      'default email', // Ganti dengan nilai email sebenarnya
                ),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MyTicketPage(), // Navigate to MyTicketPage
              ),
            );
          } else if (index == 0) {
            // Handle navigation to home or reload the current page
          }
        },
      ),
    );
  }
}
