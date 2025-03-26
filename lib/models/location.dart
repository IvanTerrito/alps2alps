import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  Location(this.position, this.address);

  LatLng position;
  String address;
}
