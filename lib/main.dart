import 'package:flutter/material.dart';
import 'package:sceno_map_flutter/sceno_map.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: ScenoMap(title: 'Sceno - Map'),
    );
  }
}


