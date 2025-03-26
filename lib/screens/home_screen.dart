import 'package:flutter/material.dart';
import 'package:ivan_territo_alps2alps/core/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/ride_booking_provider.dart';
import '../widgets/LocationPicker.dart';
import 'booking_confirmation_screen.dart';
import 'date_time_picker_screen.dart';
import 'location_picker_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  void _switchLocations() {
    final provider = Provider.of<RideBookingProvider>(context, listen: false);

    setState(() {
      final temp = provider.pickupLocation!;
      provider.setPickupLocation(provider.dropoffLocation!);
      provider.setDropoffLocation(temp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book a Ride'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<RideBookingProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocationPicker(
                  provider: provider,
                  pickupLocation: provider.pickupLocation,
                  dropOffLocation: provider.dropoffLocation,
                  onSwitchLocations: provider.pickupLocation != null &&
                          provider.dropoffLocation != null
                      ? _switchLocations
                      : () {},
                  onLocationTap: (isPickup) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LocationPickerScreen(isPickup: isPickup),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Passengers'),
                  subtitle: Text(
                      '${provider.passengerCount} ${provider.passengerCount == 1 ? 'passenger' : 'passengers'}'),
                  contentPadding: EdgeInsets.only(left: 16),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: provider.passengerCount > 1
                            ? () {
                                provider.setPassengerCount(
                                    provider.passengerCount - 1);
                              }
                            : null,
                        iconSize: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '${provider.passengerCount}',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: provider.passengerCount < 10
                            ? () {
                                provider.setPassengerCount(
                                    provider.passengerCount + 1);
                              }
                            : null,
                        iconSize: 32,
                      ),
                    ],
                  ),
                  onTap: null,

                  /// In case we want to navigate to the passenger selection screen to add more details about the passengers later
                  /* () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PassengerSelectionScreen(
                          initialCount: provider.passengerCount,
                        ),
                      ),
                    );
                    if (result != null) {
                      provider.setPassengerCount(result);
                    }
                  } */
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  leading: Icon(Icons.access_time),
                  trailing: Icon(Icons.chevron_right),
                  title: Text('Date & Time'),
                  subtitle: provider.selectedDateTime != null
                      ? Text(
                          DateFormat('d MMMM yyyy - HH:mm')
                              .format(provider.selectedDateTime!),
                        )
                      : Text('Select when you need the ride'),
                  contentPadding: EdgeInsets.only(left: 16, right: 8),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DateTimePickerScreen(
                          initialDateTime:
                              provider.selectedDateTime ?? DateTime.now(),
                        ),
                      ),
                    );
                    if (result != null) {
                      provider.setSelectedDateTime(result);
                    }
                  },
                ),
                Spacer(),
                GestureDetector(
                  onTap: provider.isRideBookingComplete
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Fill all the data before to be able to book the ride'),
                            ),
                          );
                        },
                  child: ElevatedButton(
                    onPressed: provider.isRideBookingComplete
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookingConfirmationScreen(),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text('BOOK THE RIDE'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
