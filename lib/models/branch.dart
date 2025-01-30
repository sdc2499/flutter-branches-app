class Branch {
  final int id;
  final String name;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    var lat = (json['lat'] + 0.0);
    var lng = (json['lng'] + 0.0);
    return Branch(
        id: json['id'],
        name: json['display_name'],
        address: json['address'],
        phone: json['phone'],
        latitude: lat,
        longitude: lng);
  }
}
