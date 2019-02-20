import 'package:flutter/material.dart';
import 'package:sceno_map_flutter/models/event.dart';

class EventIcon extends StatelessWidget {

  Event event;

  EventIcon({Key key, this.event}): super(key: key);

  @override
  Widget build(BuildContext context) {

    var icon = Icon(
      _getIconData(),
      color: _getColor(),
      size: 35,
    );

    return IconButton(
        icon: icon,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  contentPadding: EdgeInsets.all(10.0),
                  title: Text(event.title),
                  children: <Widget>[
                    ListTile(title: Text(event.address), leading: Icon(Icons.location_on, color: Colors.red),),
                    ListTile(title: Text(event.startDate), leading: Icon(Icons.timer, color: Colors.blue),),
                    ListTile(title: Text(event.endDate), leading: Icon(Icons.timer_off, color: Colors.grey),),
                    ListTile(title: Text(event.category), leading: Icon(Icons.category, color: Colors.green),),
                  ],
                );
              });

          print('press: ${event.id}');
        });
  }

  IconData _getIconData() {
    switch(event.category) {
      case "Musique" :
        return Icons.music_note;
        break;
      case "Spectacle" :
        return Icons.local_activity;
        break;
      case "CinÃ©ma" :
        return Icons.local_movies;
        break;
      case "LittÃ©rature" :
        return Icons.book;
        break;
      default:
        return Icons.add_a_photo;
    }
  }

  Color _getColor() {
    var defaultColor = Colors.black;
    switch (event.category) {
      case "Musique":
        defaultColor = Colors.blue;
        break;
      case "LittÃ©rature":
        defaultColor = Colors.red;
        break;
      case "Danse":
        defaultColor = Colors.orange;
        break;
      case "Exposition":
        defaultColor = Colors.amber;
        break;
      case "CinÃ©ma" :
        defaultColor.green;
        break;
    }
    return defaultColor;
  }

}