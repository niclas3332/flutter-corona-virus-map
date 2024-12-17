import 'package:google_maps_flutter/google_maps_flutter.dart';

class Marker {
  final String id;
  final String country;
  final int lastUpdate;
  final LatLng position;
  final int confirmed;
  final int deaths;
  final int recovered;

  Marker(
      {required this.id,
      required this.country,
      required this.lastUpdate,
      required this.position,
      required this.confirmed,
      required this.deaths,
      required this.recovered});
}