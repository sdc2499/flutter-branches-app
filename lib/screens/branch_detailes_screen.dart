import 'package:flutter/material.dart';
import '../models/branch.dart';

class BranchDetailesScreen extends StatelessWidget {
  final Branch branch;

  BranchDetailesScreen({required this.branch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(branch.name, textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildDetailRow(Icons.location_on, 'כתובת:', branch.address),
            _buildDetailRow(Icons.phone, 'טלפון:', branch.phone),
            // _buildDetailRow(Icons.access_time, 'שעות פתיחה:', branch.openingHours),
            SizedBox(height: 20),

            // כפתורי פעולה
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton('משלוח עד הבית', Colors.black, Colors.white),
                _buildActionButton('איסוף עצמי', Colors.white, Colors.black),
                _buildActionButton('נווט לסניף', Colors.white, Colors.black),
              ],
            ),

            SizedBox(height: 20),

            // מפה (אפשר לשלב Google Maps)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: Center(
                    child:
                        Text('כאן תוצג מפה', textDirection: TextDirection.rtl)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Icon(icon, color: Colors.amber),
          SizedBox(width: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Expanded(child: Text(value, textDirection: TextDirection.rtl)),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color bgColor, Color textColor) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      onPressed: () {},
      child: Text(text),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../models/branch.dart';

// class BranchDetailesScreen extends StatelessWidget{
//   final Branch branch;
//   BranchDetailesScreen({required this.branch});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(branch.name),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               'כתובת:',
//               style: TextStyle(fontWeight: FontWeight.bold),
//               textDirection: TextDirection.rtl,
//             ),
//             Text(
//               branch.address,
//               textDirection: TextDirection.rtl,
//             ),
//             SizedBox(
//               height: 20,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
