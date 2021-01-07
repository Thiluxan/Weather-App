import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'weather.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (myController.text != null) {
              var location = myController.text.toString().toLowerCase();
              http.Response response = await http.get(
                  "http://api.openweathermap.org/data/2.5/weather?q=$location&units=imperial&appid=6253821d856877479c1a5f425af3ed30");
              var results = jsonDecode(response.body);
              var fTemp = double.parse(results['main']['temp'].toString());
              var cTemp = (fTemp - 32) * (5 / 9);
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => Weather(
                          location,
                          cTemp.toStringAsFixed(2).toString(),
                          results['weather'][0]['description'].toString(),
                          results['weather'][0]['main'].toString(),
                          results['main']['humidity'].toString(),
                          results['wind']['speed'].toString())));
            } else {
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("Please Enter a Location"),
                  );
                },
              );
            }
          },
          tooltip: 'Show the current weather',
          child: FaIcon(FontAwesomeIcons.search)),
    );
  }
}
