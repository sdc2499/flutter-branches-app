import 'package:flutter/material.dart';
import '../models/branch.dart';

class BranchDetailesScreen extends StatelessWidget{
  final Branch branch;
  BranchDetailesScreen({required this.branch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(branch.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'כתובת:',
              style: TextStyle(fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            Text(
              branch.address,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
