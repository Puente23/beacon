import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Ubicacion extends StatefulWidget {
  const Ubicacion({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Ubicacion> {
  Position? _currentPosition;
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentPosition != null)
              Text(
                  "LAT: ${_currentPosition!.latitude}, LNG: ${_currentPosition!.longitude}"),
            ElevatedButton(
              child: Text("Ubicación"),
              onPressed: () {
                _getCurrentLocation();
              },
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Ubicacion'),
            ),
            ElevatedButton(
              child: Text("Guardar"),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }
}
