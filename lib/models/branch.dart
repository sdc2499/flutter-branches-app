class Branch {
  final String name;
  final String address;
  final double latitude;
  final double longtitude;

  Branch(
      {required this.name,
      required this.address,
      required this.latitude,
      required this.longtitude});

  factory Branch.fromJson(Map<String, dynamic> json) {
    var lat = (json['lat'] + 0.0);
    var lng = (json['lng'] + 0.0);
    return Branch(
        name: json['display_name'],
        address: json['address'],
        latitude: lat,
        longtitude: lng);
  }
}
