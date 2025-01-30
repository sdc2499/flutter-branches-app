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
  List<Branch> filteredBranches = []; 
  TextEditingController searchController = TextEditingController(); 
  Color textColor = Colors.black;
  Color errorColor = Colors.red;
  bool userAgreed = false;
  Position? userLocation;

  Future<void> showLocationDialog(BuildContext context) async {
    bool? agreement = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("גישה למיקום"),
        content: Text("כדי להציג את הסניפים הקרובים אליך יש לאפשר גישה למיקום"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("לא עכשיו"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("אישור"),
          ),
        ],
      ),
    );

    if (agreement == true) {
      Position position = await _determinePosition();
      setState(() {
        userAgreed = true;
        userLocation = position;
        branches = getSortedBranches();
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('שירותי המיקום אינם זמינים');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
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
    branches.then((list) {
      setState(() {
        filteredBranches = list; 
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLocationDialog(context);
    });

    searchController.addListener(() {
      filterBranches();
    });
  }

  Future<List<Branch>> getSortedBranches() async {
    try {
      if (userLocation == null) {
        userLocation = await _determinePosition();
      }

      List<Branch> branchList = await branches;
      branchList.sort((a, b) {
        double distanceA = Geolocator.distanceBetween(userLocation!.latitude,
            userLocation!.longitude, a.latitude, a.longitude);
        double distanceB = Geolocator.distanceBetween(userLocation!.latitude,
            userLocation!.longitude, b.latitude, b.longitude);
        return distanceA.compareTo(distanceB);
      });

      return branchList;
    } catch (e) {
      print("⚠️ לא ניתן לקבל מיקום: ${e}");
      return await branches;
    }
  }

  void filterBranches() async {
    String query = searchController.text.toLowerCase();
    List<Branch> allBranches = await branches;
    setState(() {
      filteredBranches = allBranches
          .where((branch) =>
              branch.name.toLowerCase().contains(query) ||
              branch.address.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('סניפים'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'חפש סניף...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: branches,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'שגיאה בטעינת הסניפים: ${snapshot.error}',
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
                  return ListView.builder(
                    itemCount: filteredBranches.length,
                    itemBuilder: (context, index) {
                      final branch = filteredBranches[index];
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
