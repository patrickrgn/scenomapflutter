import 'package:flutter/material.dart';
import 'package:sceno_map_flutter/ui/sceno_map.dart';


void main() => runApp(Sceno());

class Sceno extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sceno Map Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScenoMap(title: 'Sceno - Map'),
    );
  }
}


