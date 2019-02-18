import 'package:flutter/material.dart';
import 'package:sceno_map_flutter/models/event.dart';

class EventIcon extends StatelessWidget {

  Event event;

  EventIcon({Key key, this.event}): super(key: key);

  @override
  Widget build(BuildContext context) {

    var icon = Icon(
      Icons.location_on,
      color: event.getColor(),
      size: 35,
    );

    return IconButton(
        icon: icon,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text(event.title),
                  children: <Widget>[
                    Text("Adresse : ${event.address}"),
                    Text("Début : ${event.startDate}"),
                    Text("Fin : ${event.endDate}")
                  ],
                );
              });

          print('press: ${event.id}');
        });
  }


}