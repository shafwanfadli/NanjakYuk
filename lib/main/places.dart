class Place {
  final String name;
  final String location;
  final double rating;
  final String imageUrl;
  final String description;
  final String price;

  Place({
    required this.name,
    required this.location,
    required this.rating,
    required this.imageUrl,
    required this.description,
    required this.price,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'],
      location: json['location'],
      rating: json['rating'].toDouble(),
      imageUrl: json['imageUrl'],
      description: json['description'],
      price: json['price'],
    );
  }
}
