import 'package:flutter/material.dart';

import 'theme.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.title});

  final String title;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CpTheme.of(context).backgroundColor,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Name'),
            Text('Description'),
            Container(
              height: 200,
              width: 200,
              color: Colors.red,
            ),
            Column(
              children: [
                TextField(),
                TextField(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
