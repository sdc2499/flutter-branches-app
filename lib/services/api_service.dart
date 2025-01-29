import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/branch.dart';

class ApiService {
  static const String url = 'https://shop.roladin.co.il/app_data/data/branches';
  static Future<List<Branch>> fetchBranches() async {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonRes = json.decode(res.body);
      final branchesData = jsonRes['data']['branches'] as Map<String, dynamic>;
      return branchesData.values.map((b) => Branch.fromJson(b)).toList();
    } else {
      throw Exception('Failed to load branches');
    }
  }
}
