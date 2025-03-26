import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../core/constants/strings.dart';
import '../models/location.dart';

class GeocodingService {
  static final String _apiKey = GOOGLE_MAPS_API;

  static Future<Location?> getLocationFromAddress(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'OK') {
          /// Getting the first (most accurate) result, we could show N results and let the user choose
          final location = jsonResponse['results'][0]['geometry']['location'];
          return Location(LatLng(location['lat'], location['lng']), address);
        } else {
          debugPrint('Geocoding failed: ${jsonResponse['status']}');
          return null;
        }
      } else {
        debugPrint('HTTP error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching location: $e');
      return null;
    }
  }

  static Future<Location?> getAddressFromLocation(LatLng position) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'OK') {
          /// Getting the first (most accurate) result, we could show N results and let the user choose
          final firstResult = jsonResponse['results'][0];
          final formattedAddress = firstResult['formatted_address'];

          return Location(position, formattedAddress);
        } else {
          debugPrint('Reverse Geocoding failed: ${jsonResponse['status']}');
          return null;
        }
      } else {
        debugPrint('HTTP error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching address: $e');
      return null;
    }
  }
}
