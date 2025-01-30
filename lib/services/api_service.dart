import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../models/branch.dart';

class ApiService {
  static Future<List<Branch>> fetchBranches() async {
    // טוען את הנתונים מקובץ ה-JSON
    String data = await rootBundle.loadString('assets/branches.json');
    Map<String, dynamic> json = jsonDecode(data);
    print("💕💕💕::: ${json}");
    List<Branch> branchList = [];

    // לולאת for כדי להמיר את הסניפים לאובייקטים של Branch
    json['data']['branches'].forEach((key, value) {
      var lat = (value['lat'] + 0.0);
      var lng = (value['lng'] + 0.0);
      Branch branch = Branch(
        id: value['id'],
        name: value['display_name'],
        address: value['address'],
        phone: value['phone'],
        latitude: lat,
        longitude: lng,
      );
      branchList.add(branch);
    });
    print("oh yeh my branch list:::😁 ${branchList}");
    return branchList;
  }
}

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/branch.dart';

// class ApiService {
//   static const String url = 'https://shop.roladin.co.il/app_data/data/branches';
//   static Future<List<Branch>> fetchBranches() async {
//     final res = await http.get(Uri.parse(url));
//     print("💕💕💕::: ${res.body}");
//     if (res.statusCode == 200) {
//       final Map<String, dynamic> jsonRes = json.decode(res.body);
//       final branchesData = jsonRes['data']['branches'] as Map<String, dynamic>;
//       return branchesData.values.map((b) => Branch.fromJson(b)).toList();
//     } else {
//       throw Exception('Failed to load branches');
//     }
//   }
// }
