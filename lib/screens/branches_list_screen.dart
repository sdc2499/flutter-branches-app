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
  List<Branch> branchList = [];
  List<Branch> filteredBranches = [];
  TextEditingController searchController = TextEditingController();
  Color textColor = Colors.black;
  Color errorColor = Colors.red;
  bool userAgreed = false;
  Position? userLocation;
  bool isSorting = false;

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
      setState(() {
        isSorting = true;
      });

      Position position = await _determinePosition();

      setState(() {
        userAgreed = true;
        userLocation = position;
      });

      List<Branch> sortedBranches = await getSortedBranches();

      setState(() {
        branchList = sortedBranches;
        filteredBranches = sortedBranches;
        isSorting = false;
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
        branchList = list;
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

      List<Branch> sortedList = List.from(branchList);
      sortedList.sort((a, b) {
        double distanceA = Geolocator.distanceBetween(userLocation!.latitude,
            userLocation!.longitude, a.latitude, a.longitude);
        double distanceB = Geolocator.distanceBetween(userLocation!.latitude,
            userLocation!.longitude, b.latitude, b.longitude);
        return distanceA.compareTo(distanceB);
      });

      return sortedList;
    } catch (e) {
      print("⚠️ לא ניתן לקבל מיקום: ${e}");
      return branchList;
    }
  }

  void filterBranches() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredBranches = branchList
          .where((branch) =>
              branch.name.toLowerCase().contains(query) ||
              branch.address.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('סניפים'),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'מצא סניף...',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              )),
        ),
        body: Column(children: [
          Expanded(
              child: isSorting
                  ? Center(child: CircularProgressIndicator())
                  : filteredBranches.isEmpty
                      ? Center(child: Text('אין תוצאות לחיפוש'))
                      : ListView.builder(
                          itemCount: filteredBranches.length,
                          itemBuilder: (context, index) {
                            final branch = filteredBranches[index];
                            return Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.location_on,
                                      color: Colors.amber),
                                  title: Text(
                                    branch.name,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    branch.address,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700]),
                                  ),
                                  trailing: Icon(Icons.chevron_right,
                                      color: Colors.black),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BranchDetailesScreen(
                                                branch: branch),
                                      ),
                                    );
                                  },
                                ),
                                Divider(),
                              ],
                            );
                          },
                        )),
        ]));
  }
}
