import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ivan_territo_alps2alps/core/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../models/location.dart';
import '../providers/ride_booking_provider.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RideBookingProvider>(context);

    // Ensure all required data is present
    if (provider.pickupLocation == null ||
        provider.dropoffLocation == null ||
        provider.selectedDateTime == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Booking Error')),
        body: Center(
          child: Text('Booking information is incomplete'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Booking'),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: 300,
            child: GoogleMap(
              initialCameraPosition: _calculateInitialCameraPosition(
                provider.pickupLocation!,
                provider.dropoffLocation!,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('pickup'),
                  position: provider.pickupLocation!.position,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure,
                  ),
                ),
                Marker(
                  markerId: MarkerId('dropoff'),
                  position: provider.dropoffLocation!.position,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  ),
                ),
              },
              rotateGesturesEnabled: false,
              scrollGesturesEnabled: false,
              zoomGesturesEnabled: false,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 220,
                ),
                SizedBox(height: 20),
                Card(
                  surfaceTintColor: PCBlue,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Booking Summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Divider(),
                        Row(
                          spacing: 4,
                          children: [
                            Icon(Icons.location_on, color: PCBlue),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PICK-UP LOCATION',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    provider.pickupLocation?.address ?? '',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          spacing: 4,
                          children: [
                            Icon(Icons.location_pin, color: PCRed),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DROP-OFF LOCATION',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(provider.dropoffLocation?.address ?? ''),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          spacing: 4,
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TOTAL PASSENGERS',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${provider.passengerCount} ${provider.passengerCount == 1 ? 'Passenger' : 'Passengers'}',
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          spacing: 4,
                          children: [
                            Icon(Icons.access_time),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'RIDE DATE & TIME',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormat('d MMMM yyyy - HH:mm')
                                      .format(provider.selectedDateTime!),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Go back to change any of the booking details",
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Simulate booking confirmation
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Booking Confirmed!'),
                        content:
                            Text('Your ride has been booked successfully.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.green,
                  ),
                  child: Text('CONFIRM THE BOOKING'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to calculate camera position to include both locations
  CameraPosition _calculateInitialCameraPosition(
    Location pickup,
    Location dropOff,
  ) {
    // Calculate the center point between pickup and dropOff
    final centerLat =
        (pickup.position.latitude + dropOff.position.latitude) / 2;
    final centerLng =
        (pickup.position.longitude + dropOff.position.longitude) / 2;

    // Calculate the zoom level based on the distance between locations
    final distance = _calculateDistance(pickup.position, dropOff.position);
    double zoom = 14; // Default zoom

    // Adjust zoom based on distance (you might need to fine-tune these values)
    if (distance < 1) {
      zoom = 16;
    } else if (distance < 5) {
      zoom = 14;
    } else if (distance < 10) {
      zoom = 12;
    } else {
      zoom = 10;
    }

    return CameraPosition(
      target: LatLng(centerLat, centerLng),
      zoom: zoom,
    );
  }

  // Haversine formula to calculate distance between two points
  double _calculateDistance(LatLng point1, LatLng point2) {
    const R = 6371; // Radius of the earth in km
    final lat1 = point1.latitude * (3.14159 / 180);
    final lat2 = point2.latitude * (3.14159 / 180);
    final latDiff = (point2.latitude - point1.latitude) * (3.14159 / 180);
    final lngDiff = (point2.longitude - point1.longitude) * (3.14159 / 180);

    final a = sin(latDiff / 2) * sin(latDiff / 2) +
        cos(lat1) * cos(lat2) * sin(lngDiff / 2) * sin(lngDiff / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }
}
