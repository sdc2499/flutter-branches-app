import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/branch.dart';
import 'branch_detailes_screen.dart';
import '../services/api_service.dart';

class BranchesListScreen extends StatefulWidget {
  @override
  _BranchesListScreenState createState() => _BranchesListScreenState();
}

class _BranchesListScreenState extends State<BranchesListScreen> {
  late Future<List<Branch>> branches;
  Color textColor = Colors.black;
  Color errorColor = Colors.red;

  Future<void> showLocationDialog(BuildContext context) async {
    bool userAgreed = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("גישה למיקום"),
              content: Text(
                  "כדי להציג את הסניפים הקרובים אליך יש לאפשר גישה למיקום"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("לא עכשיו")),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("אישור"))
              ],
            ));
    if (userAgreed == true) {
      _determinePosition();
    }
  }

  Future<Position> _determinePosition() async {
    bool servieEnabled;
    LocationPermission permission;

    servieEnabled = await Geolocator.isLocationServiceEnabled();
    if (!servieEnabled) {
      throw Exception('שירותי המיקום אינם זמינים');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('הרשאת המיקום נדחתה');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('הרשאת המיקום נדחתה לצמיתות');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    branches = ApiService.fetchBranches();
  }

  Future<List<Branch>> getSortedBranches() async {
    try {
      Position userLocation = await _determinePosition();
      branches.sort((a, b) {
        double distanceA = Geolocator.distanceBetween(userLocation.latitude,
            userLocation.longitude, a.latitude, a.longitude);
        double distanceB = Geolocator.distanceBetween(userLocation.latitude,
            userLocation.longitude, b.latitude, b.longitude);
        return distanceA.compareTo(distanceB);
      });
    } catch (e) {
      print("לא ניתן לקבל מיקום: ${e}");
    }
    return branches;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'סניפים',
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                  future: getSortedBranches(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      print("branches in list:::😂 ${snapshot.data}");
                      return Center(
                        child: Text(
                          ' ${snapshot.error}שגיאה בטעינת הסניפים',
                          style: TextStyle(color: errorColor),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'אין סניפים זמינים',
                          style: TextStyle(color: errorColor),
                        ),
                      );
                    } else {
                      final branches = snapshot.data!;
                      return ListView.builder(
                        itemCount: branches.length,
                        itemBuilder: (context, index) {
                          final branch = branches[index];
                          return ListTile(
                            title: Text(
                              branch.name,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(color: textColor),
                            ),
                            subtitle: Text(
                              branch.address,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(color: textColor),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BranchDetailesScreen(branch: branch),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  }))
        ],
      ),
    );
  }
}


